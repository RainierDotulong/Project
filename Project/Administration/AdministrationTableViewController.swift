//
//  AdministrationTableViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/16/21.
//

import UIKit

class AdministrationTableViewCell : UITableViewCell {
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
}

class AdministrationTableViewController: UITableViewController {
    
    var sections = ["Current Assignments","Late Assignments","Total Cost Out","Completed Assignment"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row] {
        case "Current Assignments":
            performSegue(withIdentifier: "goToCurrentAssignments", sender: self)
        case "Late Assignments":
            performSegue(withIdentifier: "goToLateAssignments", sender: self)
        case "Total Cost Out":
            performSegue(withIdentifier: "goToTotalCostOut", sender: self)
        case "Completed Assignments":
            performSegue(withIdentifier: "goToCompletedAssignments", sender: self)
        default:
            print("Error Has Occured in Selecting the Row")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "administrationCell",for: indexPath) as? AdministrationTableViewCell {
            cell.titleLabel.text = sections[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
