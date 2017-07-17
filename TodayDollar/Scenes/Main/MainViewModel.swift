//
//  MainViewModel.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 17..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    
    struct Input {
        let buttonTrigger: Driver<(String, String)>
    }
    
    struct Output {
        let rates: Driver<ExchangeRate>
        let error: Driver<Error>
    }
    
    private let useCase: AllExchangeRatesUseCase
    
    init(useCase: AllExchangeRatesUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        
        let rates = input.buttonTrigger.flatMapLatest { (defaultText, convertText) in
            return self.useCase.exchangeRates(from: defaultText, to: [convertText])
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: ExchangeRate(base: "USD", date: Date(), rates: []))
        }
        
        return Output(rates: rates, error: errorTracker.asDriver())
    }
}
