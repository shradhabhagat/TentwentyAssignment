//
//  SearchResultsCollectionViewCell.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 24/04/22.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseIdentifier = "SearchResultsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 12.0
    }
    
    func loadUI(title: String?, image: String?){
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        
        self.imageView.sd_setShowActivityIndicatorView(true)
        self.imageView.sd_setImage(with: URL(string: "\(baseURL)\(image ?? "")"), placeholderImage: nil, options: [], completed: nil)
        
        self.titleLabel.text = title
    }
}
