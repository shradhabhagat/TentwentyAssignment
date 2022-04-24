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
    
    @IBOutlet weak var offlineLabel: UILabel!
    @IBOutlet weak var reloadDataBtn: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let bag = DisposeBag()
    
    lazy var viewModel: MoviesVVM = {
        return MoviesVVM()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.addTarget(self, action: #selector(searchTextFieldUpdated), for: .editingChanged)

        self.setupViews()
        
        self.setupBindings()
        
        self.viewModel.fetchAllMovies()
    }
    
    @objc func searchTextFieldUpdated(){
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
                self?.viewModel.filterResultsBySearch(str: str)
            })
            .disposed(by: self.bag)
    }
    
    private func setupViews(){
        self.searchBar.layer.masksToBounds = true
        self.searchBar.layer.cornerRadius = 26
        
        self.searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 48.0, height: self.searchBar.frame.height))
        self.searchBar.leftViewMode = .always
        
    
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: MovieCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        self.collectionView.register(UINib(nibName: SearchResultsCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: SearchResultsCollectionViewCell.reuseIdentifier)
    }
    
    @IBAction func didClickReloadData(_ sender: Any) {
        self.viewModel.fetchAllMovies()
    }
    
    @IBAction func didClickSearchBtn(_ sender: UIButton) {
        self.titleView.isHidden = true
        self.searchView.isHidden = false
        self.viewModel.filterResultsBySearch(str: nil)
        self.searchBar.text = nil
        self.collectionView.reloadData()
    }
    

    @IBAction func didClickClearTextBtn(_ sender: UIButton) {
        self.titleView.isHidden = false
        self.searchView.isHidden = true
        self.collectionView.reloadData()
    }
    
    private func setupBindings(){
        viewModel.error
            .drive(onNext: { [weak self] message in
                if let message = message{
                    print("Error: " + message)
                    Utilities.showAlert(vc: self, title: "Error", havingSubtitle: message, buttonName: "Retry") {
                        self?.viewModel.fetchAllMovies()
                    }
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
                    self?.reloadDataBtn.isHidden = false
                    self?.offlineLabel.isHidden = false
                } else{
                    self?.offlineLabel.isHidden = true
                    self?.reloadDataBtn.isHidden = true
                    print("Success response: \(response.items)")
                }
                
                self?.collectionView.reloadData()
            })
            .disposed(by: bag)
        
        viewModel.searchMovieItems
            .drive(onNext: { [weak self] _ in
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
        switch self.titleView.isHidden{
        case true:
            return self.viewModel.searchDataSource?.count ?? 0
        case false:
            return self.viewModel.dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch self.titleView.isHidden{
        case true:
            if !(searchBar.text?.isEmpty ?? true){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchResultsCollectionViewCell
                let data = self.viewModel.searchDataSource?[indexPath.row]
                cell.loadUI(title: data?.title, image: data?.poster_path)
                return cell
            } else{
                fallthrough
            }
        case false:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
            let data = self.viewModel.dataSource[indexPath.row]
            cell.loadUI(title: data.title, image: data.poster_path)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.titleView.isHidden{
        case true:
            if !(searchBar.text?.isEmpty ?? true){
                return CGSize(width: collectionView.frame.width, height: 100)
            } else{
                let width = (collectionView.frame.width - 10) / 2
                return CGSize(width: width, height: width / 1.75)
            }
        case false:
            let width = collectionView.frame.width
            return CGSize(width: width, height: width / 1.75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.viewModel.dataSource.count - 1), !self.titleView.isHidden{
            self.viewModel.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movieId: Int?
        switch self.titleView.isHidden{
        case true:
            movieId = self.viewModel.searchDataSource?[indexPath.row].id
        case false:
            movieId = self.viewModel.dataSource[indexPath.row].id
        }
        
        guard let movieId = movieId else {
            return
        }
        let vc = MovieDetailsViewController(movieID: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
