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
        let trigger: Driver<Void>
        let buttonTrigger: Driver<RateCode>
    }
    
    struct Output {
        let peroidRates: Driver<[ExchangeRate]>
        let error: Driver<Error>
    }
    
    private let useCase: AllExchangeRatesUseCase
    
    init(useCase: AllExchangeRatesUseCase) {
        self.useCase = useCase
    }
    
    let bag: DisposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        
        let peroidRates = input.buttonTrigger
            .flatMapLatest { (rateCode) in
                return self.useCase.historicalRates(from: rateCode.baseCode, to: [rateCode.symbolCode], period: 7)
                    .trackError(errorTracker)
                    .asDriver(onErrorJustReturn: [])
        }
        
        return Output(peroidRates: peroidRates, error: errorTracker.asDriver())
    }
}
