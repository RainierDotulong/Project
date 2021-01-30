//
//  UserTableViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/15/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import NotificationBannerSwift


class UserTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var jobLabel: UILabel!
    
    func configureCell(data : UserData) {
        nameLabel.text = data.name
        jobLabel.text = data.occupation
    }
    
}

class UserTableViewController: UITableViewController {
    
    var dataArray = [UserData]()
    var name : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        print("Get UserData")
        let db = Firestore.firestore()
        db.collection("UserData").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("error getting documents \(error)")
            } else {
                guard let snap = querySnapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let name = data["name"] as? String
                    let occupation = data["occupation"] as? String
                    
                    let Data = UserData(name: name!, occupation: occupation!)
                    self.dataArray.append(Data)
                }
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func addUserButtonPressed(_ sender: UIBarButtonItem) {
        print("Add User")
        let alert = UIAlertController(title: "New Item", message: "Please Specify Item", preferredStyle: .alert)
        
        alert.addTextField {(textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        alert.addTextField {(textField) in
            textField.placeholder = "Occupation"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        }
        let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            print("OK Button Pressed")
            let textField = alert.textFields![0]
            let textField1 = alert.textFields![1]
            print(textField.text ?? "")
            print(textField1.text ?? "")
            let newUserData = UserData(name: textField.text!, occupation: textField1.text!)
            self.dataArray.append(newUserData)
            print(newUserData)
            let documentId = UserData.create(userData: newUserData)
            if documentId != "error" {
                let banner = StatusBarNotificationBanner(title: "UserData Record Uploaded!", style: .success)
                banner.show()
            }
            else {
                let banner = StatusBarNotificationBanner(title: "Error Uploading UserData Record!", style: .danger)
                banner.show()
            }
            self.tableView.reloadData()
            guard textField.text ?? "" != "" && textField1.text ?? "" != "" else {
                print("incomplete Data")
                let dialogMessage = UIAlertController(title: "Incomplete Data", message: "TextField Empty", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("OK Button Tapped")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UserCurrentAssignmentsTableViewController
        {
            let vc = segue.destination as? UserCurrentAssignmentsTableViewController
            vc?.name = name
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        name = cell.nameLabel.text!
        performSegue(withIdentifier: "goToUserCurrentAssignment", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",for: indexPath) as? UserTableViewCell {
            print(dataArray)
            cell.configureCell(data: dataArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
}
