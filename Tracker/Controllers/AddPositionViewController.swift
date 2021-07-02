//
//  AddPositionViewController.swift
//  Tracker
//
//  Created by Brad's MacBook on 6/14/21.
//

import UIKit

class AddPositionViewController: UIViewController {
    @IBOutlet weak var buyTypeButton: UIBarButtonItem!
    @IBOutlet weak var tickerNameTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var numberPurchasedTextField: UITextField!
    @IBOutlet weak var numberPurchasedLabel: UILabel!
    
    var securityType: String?
    var buyType: String = "Shares"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Positions.plist")
    var positions = [Position]()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPositions()
    }
    
    @IBAction func dollarsButtonPressed(_ sender: UIBarButtonItem) {
        if(buyTypeButton.title == "Buy in Dollars"){
            buyTypeButton.title = "Buy in Shares"
            buyType = "Shares"
            numberPurchasedLabel.text = "Dollar amount\n purchased:"
        }
        else{
            buyTypeButton.title = "Buy in Dollars"
            buyType = "Dollars"
            numberPurchasedLabel.text = "Shares purchased:"
            
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let position = Position()
        position.tickerName = tickerNameTextField.text!
        position.avgCost = Double(costTextField.text!)!
        position.numberOwned = Double(numberPurchasedTextField.text!)!
        
//        if(buyType == "Shares"){
//            buyShares()
//        }
//        else{
//            buyDollars()
//        }
        
        if(securityType == "Add Shares"){
            position.type = 0
        }
        else if(securityType == "Add Option"){
            position.type = 1
        }
        else{
            position.type = 2
        }
        
        let openPosition = checkIfAlreadyOpen(newPosition: position)
        
        if openPosition{
            print("position already open")
        }
        else{
            print("new Position")
            position.calcTotalValue()
            positions.append(position)
        }

        //positions.append(position)
        savePositions()
        self.performSegue(withIdentifier: "closeAddView", sender: self)
    }
    
    //MARK: Functions to add a position
    
    func buyShares(){
        let newPosition = Position()
        newPosition.tickerName = tickerNameTextField.text!
        newPosition.avgCost = Double(costTextField.text!)!
        newPosition.numberOwned = Double(numberPurchasedTextField.text!)!
    }
    
    func buyDollars(){
        let newPosition = Position()
        newPosition.tickerName = tickerNameTextField.text!
        newPosition.avgCost = Double(costTextField.text!)!
        newPosition.numberOwned = Double(numberPurchasedTextField.text!)!
        
    }
    
    //MARK: Function to add to existing position if one exists
    func checkIfAlreadyOpen(newPosition: Position) -> Bool{
        var exists: Bool = false
        for pos in positions{
            if ((pos.tickerName == newPosition.tickerName) && (pos.type == newPosition.type)){
                print("Pos type:\(pos.type), Position type:\(newPosition.type)")
                exists = true
                let newTotalCount = pos.numberOwned + newPosition.numberOwned
                let currentTotalVal = pos.avgCost * Double(pos.numberOwned)
                let newTotalVal = newPosition.avgCost * Double(newPosition.numberOwned)
                let newAvgCost = (currentTotalVal + newTotalVal) / Double(newTotalCount)
                //let newTotal = newAvgCost * Double(newTotalCount)
                pos.avgCost = newAvgCost
                pos.numberOwned = newTotalCount
                pos.calcTotalValue()
                
            }
        }
        return exists
    }
    
    
    //MARK: Functions to load and save open position data
    func loadPositions(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                positions = try decoder.decode([Position].self, from: data)
            } catch {
                print("Error decoding")
            }
        }
        
    }
    
    func savePositions(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(positions)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding")
        }
        
    }
}

