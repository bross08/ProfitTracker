//
//  ViewController.swift
//  Tracker
//
//  Created by Brad's MacBook on 6/10/21.
//

import UIKit

class OpenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addSharesButton: UIButton!
    @IBOutlet weak var addOptionButton: UIButton!
    @IBOutlet weak var addCryptoButton: UIButton!
    
    var securityType: String = ""
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Positions.plist")
    var positions = [Position]()
    var activePosition = Position()
    var closeButton: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadPositions()
        tableView.reloadData()
        addSharesButton.layer.cornerRadius = addSharesButton.frame.size.height / 5
        addOptionButton.layer.cornerRadius = addOptionButton.frame.size.height / 5
        addCryptoButton.layer.cornerRadius = addCryptoButton.frame.size.height / 5
        
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.register(UINib(nibName: "OpenPositionCell", bundle: nil), forCellReuseIdentifier: "OpenCell")
        
    }
    
    @IBAction func unwindToOpenViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.loadPositions()
                self.tableView.reloadData()
            }
        }
    }
    

    
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
    
    @IBAction func reloadPressed(_ sender: UIButton) {
    
        positions = [Position]()
        savePositions()
        tableView.reloadData()
        for pos in positions{
            print(pos.tickerName)
        }
    }
    
    
    @IBAction func addPositionPressed(_ sender: UIButton) {
        
        let buttonPressed = sender
        if let buttonName = buttonPressed.titleLabel?.text {
            print(buttonName)
            securityType = buttonName
            self.performSegue(withIdentifier: "AddPosition", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "AddPosition"){
            if let navController = segue.destination as? UINavigationController,
               let destinationVC = navController.topViewController as? AddPositionViewController{
                destinationVC.securityType = securityType
            }
        }
        
        else if(segue.identifier == "SellPosition"){
            if let navController = segue.destination as? UINavigationController,
               let destinationVC = navController.topViewController as? SellPositionViewController{
                destinationVC.position = activePosition

            }
        }
    }
    
    
}


extension OpenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let position = positions[indexPath.row]
        activePosition = position
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenCell", for: indexPath) as! OpenPositionCell
        
        if(position.type == 0){
            cell.countLabel.text = "Shares: \(position.numberOwned)"
        }
        else if(position.type == 1){
            cell.countLabel.text = "Contracts: \(position.numberOwned)"
        }
        else{
            cell.countLabel.text = "\(position.numberOwned) owned"
        }
        cell.populateCell(with: position)
        //cell.tickerLabel.text = position.tickerName
        //let cost = String(format: "%.2f", position.avgCost)
        //cell.costLabel.text = "Avg Cost: $\(cost)"
        //let total = String(format: "%.2f", position.totalValue)
        //cell.totalValueLabel.text = "$\(total)"
        cell.delegate = self
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return positions.count
    }

}

extension OpenViewController: OpenPositionCellDelegate {
    func closePressed(){
        
        performSegue(withIdentifier: "SellPosition", sender: self)
    }
}
