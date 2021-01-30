//
//  ViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/7/21.
//

import UIKit
import CoreData

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}
    
class ViewController: UIViewController {

    @IBOutlet var circularImage: UIImageView!
    @IBOutlet var SignInButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    var userData = [UserProfile]()
    
    var fullName : String = ""
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make image Circular
        circularImage.roundedImage()
        //Make Button NO edges
        SignInButton.roundedButton()
        createAccountButton.roundedButton()
        getDataFromLocalStorage()
        
        if userData != [] {
            
            fullName = userData[0].fullName!
            email = userData[0].email!
            
            self.performSegue(withIdentifier: "goToHomepage", sender: self)
        }
    }
    func getDataFromLocalStorage() {
        //Core Data Context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Specify context and reqeust for core data
        let requestUserProfile : NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        do {
            userData = try context.fetch(requestUserProfile)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignIn", sender: self)
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreateAccount", sender: self)
    }
}

