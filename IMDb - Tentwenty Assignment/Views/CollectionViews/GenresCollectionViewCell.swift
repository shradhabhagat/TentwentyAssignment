//
//  GenresCollectionViewCell.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btn: UIButton!
    
    static let reuseIdentifier = "GenresCollectionViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupUI(genre: Genre_Codable?){
        if let genre = genre{
            self.btn.isHidden = false
            self.btn.isUserInteractionEnabled = false
            self.btn.setTitle(genre.name, for: .normal)
            self.btn.layer.cornerRadius = 20
        } else{
            self.btn.isHidden = true
        }
    }

}
