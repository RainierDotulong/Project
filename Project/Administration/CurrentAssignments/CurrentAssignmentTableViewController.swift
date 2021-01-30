//
//  CurrentAssignmentTableViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/18/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import NotificationBannerSwift
import JGProgressHUD
import SVProgressHUD
import QuickLook


class CurrentAssignmentTableViewCell: UITableViewCell {
    @IBOutlet var assignmentLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    
    func configureCell(data:AssignmentsModel){
        nameLabel.text = "Name: \(data.name)"
        assignmentLabel.text = "\(data.assignment)"
        statusLabel.text = "Status: Status"
        let date = NSDate(timeIntervalSince1970: data.dueDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date as Date)
        dueDateLabel.text = strDate
        creatorLabel.text = "Requested By : Admin 1"
        var totalBarang : Float = 0
        for i in 0..<data.quantity.count {
            totalBarang = data.pricePerUnit[i] * data.quantity[i] + totalBarang
        }
        let total = data.biayaTenagaKerja * Float(data.tenagaKerja) + totalBarang 
        totalLabel.text = "Total: \(total)"
        print("Successfully configured cell")
    }
}

class CurrentAssignmentTableViewController: UITableViewController {
    var dataArray = [AssignmentsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.reloadData()
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAddAssignment", sender: self)
    }
    func getData() {
        let db = Firestore.firestore()
        db.collection("assignment").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error)
            } else {
                guard let snap = querySnapshot
                else {return}
                    var totalCost: [Float] = [Float]()
                    for document in snap.documents {
                        let data = document.data()
                        let assigment = data["assignment"] as! String
                        let biaya = data["biayaTenagaKerja"] as! Float
                        let dueDate = data["dueDate"] as! Double
                        let estimasiLabaRugi = data["estimasiLabaRugi"] as! Float
                        let estimasiTagihan = data["estimasiTagihan"] as! Float
                        let namaBank = data["namaBank"] as! String
                        let noRekening = data["noRekening"] as! Int
                        let quality = data["quality"] as! String
                        let quantity = data["quantity"] as! [Float]
                        let tenagaKerja = data["tenagaKerja"] as! Int
                        let name = data["name"] as! String
                        let namaRekening = data["namaRekening"] as! String
                        let namaBarang = data["namaBarang"] as! [String]
                        let pricePerUnit = data["pricePerUnit"] as! [Float]
                        let pembeli = data["pembeli"] as! [String]
                        
                        for i in 0..<quantity.count {
                            let costBarang = Float(quantity[i]) * pricePerUnit[i]
                            totalCost.append(costBarang)
                        }
                        
                        let newAssignment = AssignmentsModel(assignment: assigment, name: name, quality: quality, tenagaKerja: tenagaKerja, biayaTenagaKerja: biaya, estimasiTagihan: estimasiTagihan, estimasiLabaRugi: estimasiLabaRugi, noRekening: noRekening, namaRekening: namaRekening, namaBank: namaBank, dueDate: dueDate, namaBarang: namaBarang , quantity: quantity, pricePerUnit: pricePerUnit, pembeli: pembeli)
        
                        self.dataArray.append(newAssignment)
                        
                         print("successfully retrieved data")
                    }
                    self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CurrentAssignmentTableViewCell{
            cell.configureCell(data: dataArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
}
