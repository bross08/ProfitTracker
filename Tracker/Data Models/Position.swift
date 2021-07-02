//
//  Position.swift
//  Tracker
//
//  Created by Brad's MacBook on 6/10/21.
//

import Foundation

class Position: Codable {
    
    var tickerName: String = ""
    var avgCost: Double = 0.0
    var numberOwned:Double = 0.0
    var type: Int = 0
    var avgSellPrice: Double = 0.0
    var open: Bool = true
    var totalValue = 0.0
    
    func calcTotalValue(){
        if(type == 1){
            totalValue = avgCost * numberOwned * 100
        }
        else{
            totalValue = avgCost * numberOwned
        }
    }
}
