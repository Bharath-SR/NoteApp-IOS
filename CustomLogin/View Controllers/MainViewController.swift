//
//  MainViewController.swift
//  CustomLogin
//  Created by YE002 on 12/04/23.
//

import UIKit
import FirebaseAuth
class MainViewController: UIViewController {
    
    @IBOutlet weak var signUpBUtton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        automaticLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        automaticLogin()
    }
    func setUpElements(){
        Utilities.styleFilledButton(signUpBUtton)
        Utilities.styleHollowButton(loginButton)
    }
    
    func automaticLogin() {
        print("Autologin success")
        if Auth.auth().currentUser != nil {
            let homeVC = ContainerController()
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        }
    }
}

