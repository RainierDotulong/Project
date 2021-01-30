//
//  CreateAccountViewController.swift
//  Project
//
//  Created by Rainier Dotulong on 1/7/21.
//

import UIKit
import TextFieldEffects
import SVProgressHUD
import FirebaseAuth
import FirebaseFirestore
import NotificationBannerSwift

class CreateAccountViewController: UIViewController {
    

    @IBOutlet var circularImage: UIImageView!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularImage.roundedImage()
        createAccountButton.roundedButton()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupKeyboardDismissRecognizer()
        //Shift elements up when keyboard comes out
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //Add Done Button on Keyboard
        addDoneButtonOnKeyboard()
    }
    //Disable Autorotation
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Dismiss Keyboard when view appears
        dismissKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Empty Text Fields
        emailTextField.text = ""
        passwordTextField.text = ""
        self.view.endEditing(true)
    }
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text != "" && passwordTextField.text != "" && fullNameTextField.text != ""{
            
            SVProgressHUD.show()
            
            //Set up a new user on our Firebase database
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    
                    print(error!)
                    //Declare Alert message
                    let dialogMessage = UIAlertController(title: "Registration Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    // Create OK button with action handler
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("Ok button tapped")
                    })
                    
                    //Add OK and Cancel button to dialog message
                    dialogMessage.addAction(ok)
                    
                    // Present dialog message to user
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                    SVProgressHUD.dismiss()
                    
                }else {
                    print("Registration Successful!")
                    let userProfile = Firestore.firestore().collection("userProfiles").document(self.emailTextField.text!)
                    userProfile.setData([
                        "fullName": self.fullNameTextField.text!,
                        "email": self.emailTextField.text!,
                        "class": "PENDING APPROVAL",
                        "password": self.passwordTextField.text!
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    SVProgressHUD.dismiss()
                    
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        }
        
        else {
            let dialogMessage = UIAlertController(title: "Fill Out TextField", message: "Input Data", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok Button Tapped")
            })
            
            dialogMessage.addAction(ok)
            
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CreateAccountViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                let keyboardShift = keyboardSize.height
                self.view.frame.origin.y -= keyboardShift - 120
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        fullNameTextField.inputAccessoryView = doneToolbar
        emailTextField.inputAccessoryView = doneToolbar
        passwordTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        fullNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
