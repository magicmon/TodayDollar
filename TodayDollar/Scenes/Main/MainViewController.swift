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
    
    @IBOutlet weak var defaultCurrencyName: UILabel!
    @IBOutlet weak var convertCurrencyName: UILabel!
    
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
            trigger: Driver.just((self.defaultCurrencyName.text ?? "", self.convertCurrencyName.text ?? "")),
            buttonTrigger: changeButton.rx.tap
                .asDriver()
                .debounce(0.3)
                .map {
                    return (self.convertCurrencyName.text ?? "", self.defaultCurrencyName.text ?? "")
        })
        
        let output = viewModel.transform(input: input)
        
        // 오늘 환율
        output.rates
            .drive(onNext: { [weak self] rate in
                self?.ratesLabel.text = "\(rate.rates.first?.basicRate ?? 0.0)"
                self?.updateDate.text = rate.date.stringValue
            }).disposed(by: bag)
        
        
        // 일주일간 환율 추이
        output.peroidRates
            .drive(onNext: { [weak self] (results) in
            
            self?.chartView.isHidden = false
            
            self?.chartView.leftAxis.gridLineDashLengths = [0.5, 0.5]
            self?.chartView.leftAxis.drawZeroLineEnabled = false
            self?.chartView.leftAxis.drawLimitLinesBehindDataEnabled = true
            self?.chartView.rightAxis.enabled = false
            self?.chartView.legend.form = .line
            self?.chartView.animate(xAxisDuration: 1.0)
            
            
            let min = results.map { $0.maxRates }.min() ?? 0.0
            let max = results.map { $0.maxRates }.max() ?? 0.0
            self?.chartView.leftAxis.axisMinimum = min - (max * 0.01)
            self?.chartView.leftAxis.axisMaximum = max + (max * 0.01)
            
            var values = [ChartDataEntry]()
            for (index, result) in results.enumerated() {
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
            
            self?.chartView.data = LineChartData(dataSet: set)
        }).disposed(by: bag)
        
        
        // 라벨 위치 변경 USD <-> KRW
        output.changedLabel.drive(onNext: { [weak self] (_) in
            let defaultName = self?.defaultCurrencyName.text
            let convertName = self?.convertCurrencyName.text
            
            self?.defaultCurrencyName.text = convertName
            self?.convertCurrencyName.text = defaultName
        }).disposed(by: bag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

