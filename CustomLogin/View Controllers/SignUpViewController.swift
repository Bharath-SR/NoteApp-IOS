//
//  SignUpController.swift
//  CustomLogin
//  Created by YE002 on 12/04/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    }
    
    
    
    func setUpElements(){
        //Hide the error label
        errorLabel.alpha = 0
        // Style the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    //Check the fields and validate that the data is correct ,if everthing is fine,returns nil . otherwise it return the error message
    
    func validateFields() -> String? {
        // check that all fields are filled
        
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all Fields."
        }
        
        //Check  if password is secured
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false  {
            return "Please make sure your password is at least 8 Characters , contains a special character and a number "
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate the fields
        
        let error = validateFields()
        
        if error != nil{
            // if somthing wrong wiht the fields , shows error message
            showError(error!)
            
        }
        else{
            // create cleaned versoin if the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            
            Auth.auth().createUser(withEmail: email, password: password){ ( result , err) in
                
                
                
                if  err != nil {
                    // there is an error while creating the user
                    self.showError("Error creating user")
                    print(err)
                }else{
                    // user created successfully
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName , "lastname":lastName ,"uid": result!.user.uid]) {(error) in
                        if error != nil{
                            self.showError("Error saving data")
                        }
                    }
                    //Trasition to the home screen
                    self.transitionToHome()
                    
                    
                }
                
            }
            
            
            
            
        }
    }
        
        func showError(_ message :String){
            errorLabel.text = message
            errorLabel.alpha = 1
        }
    func transitionToHome(){
        let homeScreenVC = ContainerController()
        view.window?.rootViewController = homeScreenVC
        view.window?.makeKeyAndVisible()
       
    }
        
        
    }
    

