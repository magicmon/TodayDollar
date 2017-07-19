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
import RxGesture
import RxAlamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var symbolCodeLabel: UILabel!
    @IBOutlet weak var baseCodeLabel: UILabel!
    
    @IBOutlet weak var ratesLabel: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var chartView: LineChartView!
    
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func bindViewModel() {
        
        viewModel = MainViewModel(useCase: NetworkUseCaseProvider().makeExchangeRatesUseCase())
        
        let input = MainViewModel.Input(
            trigger: Driver.just(),
            buttonTrigger: changeButton.rx.tap
                .asDriver()
                .debounce(0.3)
                .startWith(())
                .map {
                    return RateCode(baseCode: self.baseCodeLabel.text ?? "KRW", symbolCode: self.symbolCodeLabel.text ?? "USD")
        })
        
        let output = viewModel.transform(input: input)
        
        output.peroidRates.drive(ratesBinding).disposed(by: bag)    // 오늘 환율
        output.peroidRates.drive(periodBinding).disposed(by: bag)   // 일주일간 환율 추이
        
        output.rateCode.drive(onNext: { (rateCode) in
            self.baseCodeLabel.text = rateCode.baseCode
            self.symbolCodeLabel.text = rateCode.symbolCode
        }).disposed(by: bag)
        
        symbolCodeLabel.rx.tapGesture().when(.recognized)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .map { [weak self] _ in return self?.symbolCodeLabel.text ?? "" }
            .subscribe(pushViewInMain)
            .disposed(by: bag)
        
        baseCodeLabel.rx.tapGesture()
            .when(.recognized)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .map { [weak self] _ in return self?.baseCodeLabel.text ?? "" }
            .subscribe(pushViewInMain)
            .disposed(by: bag)
    }
}


extension MainViewController {
    var pushViewInMain: UIBindingObserver<MainViewController, String> {
        return UIBindingObserver(UIElement: self, binding: { [weak self] (vc, code) in
            
            guard let weakSelf = self else { return }
            
            guard let nextViewController = weakSelf.storyboard?.instantiateViewController(withIdentifier: "CountryListViewController") as? CountryListViewController else {
                return
            }
            
            weakSelf.navigationController?.pushViewController(nextViewController, animated: true)
            
            nextViewController.currencyCode = code
            
            nextViewController.repoObservable
                .subscribe(onNext: { text in
                    print("subscribe \(text)")
                }).disposed(by: weakSelf.bag)
        })
    }
    
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
