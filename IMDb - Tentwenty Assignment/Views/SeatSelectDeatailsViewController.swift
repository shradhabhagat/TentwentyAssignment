//
//  SeatSelectDeatailsViewController.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 24/04/22.
//

import UIKit

class SeatSelectDeatailsViewController: UIViewController {

    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var amountPayableView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paymentBtn.layer.cornerRadius = 12.0
        self.amountPayableView.layer.cornerRadius = 12.0
    }

    @IBAction func didClickBackBtn(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didClickPayBtn(_ sender: Any){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
