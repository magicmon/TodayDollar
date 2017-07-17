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
        let trigger: Driver<(String, String)>
        let buttonTrigger: Driver<(String, String)>
    }
    
    struct Output {
        let rates: Driver<ExchangeRate>
        let peroidRates: Driver<[ExchangeRate]>
        let changedLabel: Driver<Void>
        let error: Driver<Error>
    }
    
    private let useCase: AllExchangeRatesUseCase
    
    init(useCase: AllExchangeRatesUseCase) {
        self.useCase = useCase
    }
    
    let bag: DisposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        
        let mergeTrigger = Driver.merge(input.trigger, input.buttonTrigger)
        
        let rates = mergeTrigger.flatMapLatest { (defaultText, convertText) in
            return self.useCase.exchangeRates(from: convertText, to: [defaultText])
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: ExchangeRate(base: "USD", date: Date(), rates: []))
        }
        
        let peroidRates = mergeTrigger.flatMapLatest { (defaultText, convertText) in
            return self.useCase.historicalRates(from: convertText, to: [defaultText], period: 7)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
        }
        
        let changedLabel = input.buttonTrigger.flatMapLatest { (_, _) in
            return Driver.just()
        }
        
        return Output(rates: rates, peroidRates: peroidRates, changedLabel: changedLabel, error: errorTracker.asDriver())
    }
}
