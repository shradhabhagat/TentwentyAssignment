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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    
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
        
    
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: MovieCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
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
        
        viewModel.movieItems
            .drive(onNext: { [weak self] response in
                guard let response = response else { return }
                if response.isOffline{
                    print("OFFLINE RESPONSE DATA: \(response.items)")
                } else{
                    print("Success response: \(response.items)")
                }
                
                self?.collectionView.reloadData()
            })
            .disposed(by: bag)
        
        searchBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.titleView.isHidden = true
                self?.searchView.isHidden = false
                self?.collectionView.reloadData()
            })
            .disposed(by: bag)
    }
    
}



extension MoviesListingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.viewModel.dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.loadUI(title: data.title, image: data.poster_path)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.titleView.isHidden) ? (collectionView.frame.width / 1.75) : collectionView.frame.width
        return CGSize(width: width, height: collectionView.frame.width / 1.75)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Movie ID: \(self.viewModel.dataSource[indexPath.row].id)")
        let movieId = self.viewModel.dataSource[indexPath.row].id
        let vc = MovieDetailsViewController(movieID: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
