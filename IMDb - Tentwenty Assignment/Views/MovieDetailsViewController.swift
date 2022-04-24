//
//  MovieDetailsViewController.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import UIKit
import SDWebImage
import RxCocoa
import RxSwift

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var trailerBtn: UIButton!
    @IBOutlet weak var ticketBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backBtn: UIButton!

    
    var viewModel: MovieDetailsVVM?
    let bag = DisposeBag()
    
    convenience init(movieID: Int) {
        self.init(nibName: nil, bundle: nil)
        viewModel = MovieDetailsVVM(movieID: movieID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBindings()
        self.setupTools()
        self.viewModel?.fetchMovieDetail()
    }
    
    private func setupBindings(){
        viewModel?.error
            .drive(onNext: { [weak self] message in
                if let message = message{
                    print("Error: " + message)
                    Utilities.showAlert(vc: self, title: "Error", havingSubtitle: message, buttonName: "Retry") {
                        self?.viewModel?.fetchMovieDetail()
                    }
                }
            })
            .disposed(by: bag)
        
        viewModel?.isFetching
            .drive(onNext: { isFetching in
                if isFetching { Utilities.showLoader() }
                else { Utilities.hideLoader() }
            })
            .disposed(by: bag)
        viewModel?.movieDetail
            .drive(onNext: { [weak self] movieDetail in
                self?.setupUI(movieDetail: movieDetail)
            })
            .disposed(by: bag)
        backBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
        
        trailerBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.fetchMovieTrailer()
            })
            .disposed(by: bag)
        viewModel?.movieTrailer
            .drive(onNext: { [weak self] movieTrailer in
                self?.playVideo(trailer: movieTrailer)
            })
            .disposed(by: bag)
    }
    
    private func playVideo(trailer: TrailerResult_Codable?) {
        guard let key = trailer?.key else {
            return
        }
        let vc = VideoPlayerViewController(youtubeKey: key)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTools(){
        self.trailerBtn.layer.masksToBounds = true
        self.trailerBtn.layer.cornerRadius = 10.0
        self.trailerBtn.layer.borderWidth = 1.0
        self.trailerBtn.layer.borderColor = UIColor.cyan.cgColor
        
        self.ticketBtn.layer.masksToBounds = true
        self.ticketBtn.layer.cornerRadius = 10.0
        
    }
    
    
    
    private func setupUI(movieDetail: MovieDetails_Codable?){
        if let datasource = movieDetail{
            self.mainView.isHidden = false
            self.titleLabel.text = datasource.title
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let releaseDate = datasource.release_date, let dateOBJ = formatter.date(from: releaseDate){
                formatter.dateFormat = "MMM d, yyyy"
                self.releaseDateLabel.text = "In Theaters \(formatter.string(from: dateOBJ))"
            } else{
                self.releaseDateLabel.text = nil
            }
            
            self.overviewLabel.text = datasource.overview
            
            let baseURL = "https://image.tmdb.org/t/p/w500/"
            
            self.thumbnailImageView.sd_setShowActivityIndicatorView(true)
            self.thumbnailImageView.sd_setImage(with: URL(string: "\(baseURL)\(datasource.poster_path ?? "")"), placeholderImage: nil, options: [], completed: nil)
            
            self.setUpCollectionView()
            
        }else{
            self.mainView.isHidden = true
        }
    }
    
    private func setUpCollectionView() {
        if let layout = self.genresCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 80.0, height: self.genresCollectionView.frame.height)
            layout.minimumInteritemSpacing = 10.0
            layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        }
        self.genresCollectionView.dataSource = self
        self.genresCollectionView.delegate = self
        self.genresCollectionView.register(UINib(nibName: GenresCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GenresCollectionViewCell.reuseIdentifier)
    }

}

extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.genres.count ?? 0
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCollectionViewCell.reuseIdentifier, for: indexPath) as! GenresCollectionViewCell
        
        let genres = self.viewModel?.genres[indexPath.row]
        cell.setupUI(genre: genres)
        cell.btn.backgroundColor = genreColors[indexPath.row % 4]
        return cell
    }
}
