//
//  SelectSeatDateCollectionViewCell.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 24/04/22.
//

import UIKit

class SelectSeatDateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateBtn: UIButton!
    
    static let reuseIdentifier = "SelectSeatDateCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dateBtn.layer.masksToBounds = true
        self.dateBtn.layer.cornerRadius = 12.0
    }

}
