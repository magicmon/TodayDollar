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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureChart()
        
        
        searchRatesAPI()
        
        
        changeButton.rx.tap
            .asDriver()
            .do(onNext: { [weak self] _ in
                let defaultCurrency = self?.defaultCurrencyName.text
                let convertCurrency = self?.convertCurrencyName.text
                
                self?.defaultCurrencyName.text = convertCurrency
                self?.convertCurrencyName.text = defaultCurrency
            })
            .debounce(0.3)
            .drive(onNext: { [weak self] _ in
                self?.searchRatesAPI()
            }).disposed(by: bag)
    }
    
    func searchRatesAPI() {
        guard let base = self.defaultCurrencyName.text else {
            return
        }
        
        let rates = CurrencySearchAPI.sharedAPI
            .specifiecExchangeRates(by: [base], baseRate: self.convertCurrencyName.text)
        .map { (result) -> SearchResultViewModel in
            return SearchResultViewModel(searchResult: result)
        }
        
        rates.subscribe(onNext: { [weak self] (result) in
            
            guard let currency = self?.defaultCurrencyName.text else { return }
            
            self?.ratesLabel.text = result.getRates(from: currency)
            self?.updateDate.text = result.dateStr
            
        }).disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureChart() {
        chartView.leftAxis.axisMinimum = 950.0
        chartView.leftAxis.axisMaximum = 1250.0
        chartView.leftAxis.gridLineDashLengths = [0.5, 0.5]
        chartView.leftAxis.drawZeroLineEnabled = false
        chartView.leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.form = .line
        
        chartView.animate(xAxisDuration: 1.0)
        
        setChartData()
    }
}


extension MainViewController {
    
    func setChartData() {
        // Sample Data
        
        var values = [ChartDataEntry]()
        
        for count in 0...10 {
            let randomNo = arc4random_uniform(200) + 1000
            let value = ChartDataEntry(x: Double(count), y: Double(randomNo))
            
            values.append(value)
        }
        
        let set = LineChartDataSet(values: values, label: "")
        set.drawIconsEnabled = false
//        set.lineDashLengths = [5.0, 2.5]
//        set.highlightLineDashLengths = [5.0, 2.5]
        set.setColor(UIColor.black)
        set.setCircleColor(UIColor.black)
        set.lineWidth = 1.0
        set.circleRadius = 3.0
        set.drawCircleHoleEnabled = false
//        set.valueFont = UIFont.systemFont(ofSize: 9.0)
//        set.formLineDashLengths = [5.0, 2.5]
//        set.formLineWidth = 1.0
//        set.formSize = 15
//
//        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor, ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
//
//        set.fillAlpha = 1.0
//        set.fill = Fill.fillWithRadialGradient(gradient!)
//        set.drawFilledEnabled = true
        
        chartView.data = LineChartData(dataSet: set)
    }
}
