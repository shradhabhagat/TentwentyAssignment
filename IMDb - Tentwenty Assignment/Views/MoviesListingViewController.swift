//
//  MoviesListingViewController.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import UIKit
import RxCocoa
import RxSwift

class MoviesListingViewController: UIViewController {
    
    let bag = DisposeBag()
    
    lazy var viewModel: MoviesVVM = {
        return MoviesVVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
        self.setupBindings()
        
        self.viewModel.fetchAllMovies()
    }
    
    private func setupViews(){
        
    }


    private func setupBindings(){
        viewModel.error
            .drive(onNext: { message in
                if let message = message{
                    print("Error: " + message)
                }
            })
            .disposed(by: bag)
        
        viewModel.isFetching
            .drive(onNext: { isFetching in
                if isFetching { Utilities.showLoader() }
                else { Utilities.hideLoader() }
            })
            .disposed(by: bag)
        
        viewModel.successResponse
            .drive(onNext: { [weak self] response in
                guard let _ = self, let response = response else { return }
                print("Success response: \(response)")
            })
            .disposed(by: bag)
    }
}
