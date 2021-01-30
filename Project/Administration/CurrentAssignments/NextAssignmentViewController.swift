//
//  NextAssignmentViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/30/21.
//

import UIKit

class NextAssignmentViewController: UIViewController {

    var dataArrayBarang : [Barang] = [Barang]()
    var assignment : String = ""
    var name: String = ""
    var quality : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func Create() {
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
}
