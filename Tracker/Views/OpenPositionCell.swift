//
//  OpenPositionCell.swift
//  Tracker
//
//  Created by Brad's MacBook on 6/10/21.
//

import UIKit

protocol OpenPositionCellDelegate: AnyObject{
    func closePressed()
}

class OpenPositionCell: UITableViewCell {

    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    weak var delegate: OpenPositionCellDelegate?
    var currentPosition = Position()

    static let identifier = "OpenPositionCell"

    static func nib()-> UINib {
        return UINib(nibName: "OpenPositionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        closeButton.layer.cornerRadius = closeButton.frame.size.height / 5
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCell(with position:Position){
        currentPosition = position
        tickerLabel.text = position.tickerName
        costLabel.text = String(format: "Avg Cost: $%.2f", position.avgCost)
        countLabel.text = String(format: "", position.numberOwned)
        totalValueLabel.text = String(format: "Total: $%.2f", position.totalValue)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        print("Close pressed")
        delegate?.closePressed()
    }
    
}
