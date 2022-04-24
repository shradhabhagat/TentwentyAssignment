//
//  SelectHallCollectionViewCell.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 24/04/22.
//

import UIKit

class SelectHallCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var hallLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let reuseIdentifier = "SelectHallCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor(red: 0.38, green: 0.765, blue: 0.949, alpha: 1).cgColor
        self.containerView.layer.cornerRadius = 12.0
    }
    
    func setupUI(seat: Seats_Codable){
        self.timeLbl.text = seat.time
        self.hallLbl.text = seat.hall
        self.rateLbl.text = seat.duration
    }

}
