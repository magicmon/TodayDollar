//
//  CountryListViewModel.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 18..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CountryListViewModel: ViewModelType {
    
    let code = PublishSubject<String>()
    
    struct Input {
        let trigger: Driver<Void>
        let codeTrigger: Driver<String>
    }
    
    struct Output {
        let error: Driver<Error>
    }
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        
        let bag = DisposeBag()
        input.codeTrigger.drive(onNext: { text in
            print(text)
        }).disposed(by: bag)
        
        return Output(error: errorTracker.asDriver())
    }
}
