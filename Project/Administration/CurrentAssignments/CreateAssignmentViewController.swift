//
//  CreateAssignmentViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/28/21.
//
import UIKit
import Firebase
import FirebaseFirestore
import SVProgressHUD
import NotificationBannerSwift

class CreateAssignmentTableViewCell : UITableViewCell {
    @IBOutlet var namaBarangLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var pembeliLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    
    func configureCell (data: Barang ) {
        namaBarangLabel.text = data.name
        quantityLabel.text = String(data.quantity)
        pembeliLabel.text = data.pembeli
        totalLabel.text = String(data.quantity * data.pricePerUnit)
    }
    
    
}

class CreateAssignmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var assignmentTextField: UITextField!
    @IBOutlet var qualityTextField: UITextField!
    @IBOutlet var estimasiTagihanTextField: UITextField! // Harga Pokok Produksi
    @IBOutlet var estimasiLabaRugiTextField: UITextField! // %-nan
    @IBOutlet var tableView: UITableView!
    
    var dataArrayBarang : [Barang] = [Barang]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func proceedButtonPressed (_ sender: UIButton) {
        //Make sure everything is filled out
        guard assignmentTextField.text ?? "" != "" && nameTextField.text ?? "" != "" && qualityTextField.text ?? "" != "" && estimasiTagihanTextField.text ?? "" != "" && estimasiLabaRugiTextField.text != ""  else {
            print("TextField Is Empty")
            let dialogMessage = UIAlertController(title: "TextField Is Empty", message: "Please Fill Out TextFields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            return
        }
        guard datePicker != nil else {
            print("date Picker Empty")
            let dialogMessage = UIAlertController(title: "Date Picker Empty", message: "Please Select Date", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                print("OK button Pressed")
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            return
        }
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Create this Assigment?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        //Call Create Items
        var itemName : [String] = [String]()
        var itemQuantity : [Float] = [Float]()
        var itemPricePerUnit : [Float] = [Float]()
        var itemBuyer : [String] = [String]()
        
        for orderedItem in self.dataArrayBarang {
            itemName.append(orderedItem.name)
            itemQuantity.append(orderedItem.quantity)
            itemBuyer.append(orderedItem.pembeli)
            itemPricePerUnit.append(orderedItem.pricePerUnit)
        }
            let newDataArrayAssignment = AssignmentsModel(assignment: self.assignmentTextField.text!, name: self.nameTextField.text!, quality: self.qualityTextField.text!, tenagaKerja: Int(self.tenagaKerjaTextField.text!)!, biayaTenagaKerja: Float(self.biayaKerjaTextField.text!)!, estimasiTagihan: Float(self.estimasiTagihanTextField.text!)!, estimasiLabaRugi: Float(self.estimasiLabaRugiTextField.text!)!, noRekening: Int(self.noRekeningTextFIeld.text!)!, namaRekening: self.namaRekeningTextField.text!, namaBank: self.namaBankTextField.text!, dueDate: self.datePicker.date.timeIntervalSince1970, namaBarang: itemName, quantity: itemQuantity, pricePerUnit: itemPricePerUnit,pembeli : itemBuyer)
            
            let documentId = AssignmentsModel.create(assignment: newDataArrayAssignment)
            
            if documentId != "error" {
                let banner = StatusBarNotificationBanner(title: "Assignment Created", style: .success)
                banner.show()
            } else {
                print("AssignmentCreation Failed")
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        print("Add Item")
        let alert = UIAlertController(title: "New Item", message: "Please Specify Item", preferredStyle: .alert)
        
        alert.addTextField {(textField) in
            textField.placeholder = "Item Name"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        alert.addTextField {(textField) in
            textField.placeholder = "Quantity"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        alert.addTextField {(textField) in
            textField.placeholder = "Price Per Unit"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        alert.addTextField {(textField) in
            textField.placeholder = "Buyer"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            print("OK Button Pressed")
            let textField = alert.textFields![0]
            let textField1 = alert.textFields![1]
            let textField2 = alert.textFields![2]
            let textField3 = alert.textFields![3]
            print(textField.text ?? "")
            print(textField1.text ?? "")
            print(textField2.text ?? "")
            print(textField3.text ?? "")
            let newBarang = Barang(name: textField.text!, quantity: Float(textField1.text!)!, pricePerUnit: Float(textField2.text!)!, pembeli: textField3.text!)
            self.dataArrayBarang.append(newBarang)
            print(newBarang)
            self.tableView.reloadData()
            guard textField.text ?? "" != "" && textField1.text ?? "" != "" && textField2.text ?? "" != "" && textField3.text != "" else {
                print("incomplete Data")
                let dialogMessage = UIAlertController(title: "Incomplete Data", message: "TextField Empty", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("OK Button Tapped")
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                return
            }
            guard Int(textField2.text ?? "") ?? 0 != 0 else {
                print("Price per Unit is non-numerical")
                let dialogMessage = UIAlertController(title: "Error Creating Product!", message: "Price per Unit is non-numerical", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                return
            }
            guard Int(textField1.text ?? "") ?? 0 != 0 else {
                print("Quantity is non numerical")
                let dialogMessage = UIAlertController(title: "Error Adding Item!", message: "Quantity is non numerical", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                return
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
            print("Cancel button tapped")
        }
        
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArrayBarang.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as? CreateAssignmentTableViewCell{
            print(dataArrayBarang)
            cell.configureCell(data: dataArrayBarang[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

}
