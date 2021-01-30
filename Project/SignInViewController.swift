//
//  SignInViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/7/21.
//

import UIKit
import TextFieldEffects
import SVProgressHUD
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CoreData


class SignInViewController: UIViewController {

    @IBOutlet var circularImage: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    var fullName : String = ""
    var loginClass : String = ""
    var email : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImage.roundedImage()
        signInButton.roundedButton()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupKeyboardDismissRecognizer()
        //Shift elements up when keyboard comes out
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //Dismiss Keyboard when view appears
        dismissKeyboard()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func signInButtonPressed(_ sender : UIButton) {
        if emailTextField.text != "" && passwordTextField.text != ""{
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                    //Declare Alert message
                    let dialogMessage = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                    })
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(ok)
                    
                    // Present dialog message to user
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                    SVProgressHUD.dismiss()
                    
                } else {
                    print("login successful")
                    let usersProf = Firestore.firestore().collection("userProfiles").document(self.emailTextField.text!)
                    
                    usersProf.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()
                            self.loginClass = dataDescription!["class"] as! String
                            self.fullName = dataDescription!["fullName"] as! String
                            self.saveLoginData()
                        }
                else {
                   print("Profile Document does not exist")
                   //Declare Alert message
                   let dialogMessage = UIAlertController(title: "Profile Document does not exist", message: "Please Contact Administrator", preferredStyle: .alert)
                   
                   // Create OK button with action handler
                   let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                       print("Ok button tapped")
                   })
                   
                   //Add OK and Cancel button to dialog message
                   dialogMessage.addAction(ok)
                   
                   // Present dialog message to user
                   self.present(dialogMessage, animated: true, completion: nil)
               }
                    }
                }
            }
        }
        else {
            //Declare Alert message
            let dialogMessage = UIAlertController(title: "Text Field's Empty", message: "Please Input Email and Password", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    func saveLoginData() {
        //Core Data Context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Specify CoreData Entity for Profile Data
        let profile = UserProfile(context: context)
        
        profile.email = self.emailTextField.text!
        profile.fullName = self.fullName
        profile.loginClass = self.loginClass
        print("AAAAAAAAA")
        do {
            try context.save()
            print("Data Saved")
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goToHomepage", sender: self)
            
        } catch {
            print ("Error Saving Context \(error)")
            SVProgressHUD.dismiss()
            //Declare Alert message
            let dialogMessage = UIAlertController(title: "Error Saving Login Data", message: "Error Saving Context \(error)", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SignInViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                let keyboardShift = keyboardSize.height
                self.view.frame.origin.y -= keyboardShift
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomepageViewController {
            let vc = segue.destination as? HomepageViewController
            vc?.fullName = fullName
            vc?.email = emailTextField.text!
            vc?.loginClass = loginClass
        }
    }
}
