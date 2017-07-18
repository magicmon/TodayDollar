//
//  MainViewController.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 13..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import RxAlamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var symbolCodeLabel: UILabel!
    @IBOutlet weak var baseCodeLabel: UILabel!
    
    @IBOutlet weak var ratesLabel: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var chartView: LineChartView!
    
    
    let bag = DisposeBag()
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel(useCase: NetworkUseCaseProvider().makeExchangeRatesUseCase())
        
        let input = MainViewModel.Input(
            trigger: Driver.just(),
            buttonTrigger: changeButton.rx.tap
                .asDriver()
                .do(onNext: { _ in
                    let aa = self.baseCodeLabel.text
                    let bb = self.symbolCodeLabel.text
                    
                    self.baseCodeLabel.text = bb
                    self.symbolCodeLabel.text = aa
                })
                .debounce(0.3)
                .startWith(())
                .map {
                    return RateCode(baseCode: self.baseCodeLabel.text ?? "USD", symbolCode: self.symbolCodeLabel.text ?? "KRW")
        })
        
        let output = viewModel.transform(input: input)
        
        
        output.peroidRates.drive(ratesBinding).disposed(by: bag)    // 오늘 환율
        output.peroidRates.drive(periodBinding).disposed(by: bag)   // 일주일간 환율 추이
    }
}

extension MainViewController {
    var ratesBinding: UIBindingObserver<MainViewController, [ExchangeRate]> {
        return UIBindingObserver(UIElement: self, binding: { (vc, exchangeRates) in
            let rate = exchangeRates.last
            
            vc.ratesLabel.text = "\(rate?.rates.first?.basicRate ?? 0.0)"
            vc.updateDate.text = rate?.date.stringValue
        })
    }
    
    var periodBinding: UIBindingObserver<MainViewController, [ExchangeRate]> {
        return UIBindingObserver(UIElement: self, binding: { (vc, exchangeRates) in
            vc.chartView.isHidden = false
            
            vc.chartView.leftAxis.gridLineDashLengths = [0.5, 0.5]
            vc.chartView.leftAxis.drawZeroLineEnabled = false
            vc.chartView.leftAxis.drawLimitLinesBehindDataEnabled = true
            vc.chartView.rightAxis.enabled = false
            vc.chartView.legend.form = .line
            vc.chartView.animate(xAxisDuration: 1.0)
            
            
            let min = exchangeRates.map { $0.maxRates }.min() ?? 0.0
            let max = exchangeRates.map { $0.maxRates }.max() ?? 0.0
            vc.chartView.leftAxis.axisMinimum = min - (max * 0.005)
            vc.chartView.leftAxis.axisMaximum = max + (max * 0.005)
            
            var values = [ChartDataEntry]()
            for (index, result) in exchangeRates.enumerated() {
                guard let basicRate = result.rates.first?.basicRate else { continue }
                let value = ChartDataEntry(x: Double(index), y: basicRate)
                values.append(value)
            }
            
            let set = LineChartDataSet(values: values, label: "Basic Rate")
            set.drawIconsEnabled = false
            set.setColor(UIColor.black)
            set.setCircleColor(UIColor.black)
            set.lineWidth = 1.0
            set.circleRadius = 2.0
            set.drawCircleHoleEnabled = false
            
            vc.chartView.data = LineChartData(dataSet: set)
        })
    }
}
