//
//  CountryListViewController.swift
//  TodayDollar
//
//  Created by magicmon on 2017. 7. 18..
//  Copyright © 2017년 magicmon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: CountryListViewModel = {
        return CountryListViewModel()
    }()
    
    lazy var repoObservable: Observable<String> = {
        return self.viewModel.code.asObservable()
    }()
    
    var currencyCode: String? = nil {
        didSet {
            self.bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = CountryListViewModel.Input(trigger: Driver.just(),
                                               codeTrigger: Driver.just(currencyCode!))
        
        let _ = viewModel.transform(input: input)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
