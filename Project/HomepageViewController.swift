//
//  HomepageViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/7/21.
//

import UIKit

class tableViewCell: UITableViewCell {
    @IBOutlet var homepageImageView: UIImageView!
    @IBOutlet var tableLabel: UILabel!
    
}

class HomepageViewController: UIViewController {
    
    var fullName : String = ""
    var email : String = ""
    var loginClass : String = ""
    
    var sections : [String] = ["Users","Administration"]
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var greenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        tableView.roundedView()
        greenView.roundedView()
        //GetUserData()
        usernameLabel.text = fullName
        classLabel.text = loginClass
        tableView.contentSize.height = 90

        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension HomepageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapping")
        switch sections[indexPath.row] {
        case "Users":
            performSegue(withIdentifier: "goToUser", sender: self)
        case "Administration":
            performSegue(withIdentifier: "goToAdministration", sender: self)
        default:
            print("Error Has Occured in Selecting the Row")
        }
    }
}
extension HomepageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "homepageCell", for: indexPath) as! tableViewCell
            
        cell.tableLabel.text = sections[indexPath.row]
        cell.homepageImageView.image = UIImage(named: "Logo")
        cell.homepageImageView.roundedImage2()
            return cell
    }
}
