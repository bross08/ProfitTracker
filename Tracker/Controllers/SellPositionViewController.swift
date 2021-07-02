//
//  SellPositionViewController.swift
//  Tracker
//
//  Created by Brad's MacBook on 6/28/21.
//

import UIKit

class SellPositionViewController: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var position = Position()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        nameLabel.text = "\(position.tickerName)"
    }
    
}
