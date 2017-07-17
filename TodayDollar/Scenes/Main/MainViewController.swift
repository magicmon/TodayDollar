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
        
        output.rates
            .drive(onNext: { [weak self] rate in
                self?.ratesLabel.text = "\(rate.rates.first?.basicRate ?? 0.0)"
                self?.updateDate.text = rate.date.stringValue
            }).disposed(by: bag)
        
        
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

