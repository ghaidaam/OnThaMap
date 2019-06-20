//
//  LoginVC.swift
//  OnThaMap
//
//  Created by Ghaida Almahmoud on 14/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func login(_ sender: UIButton){
        updateUI(processing: true)
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces),
        let password = passwordField.text?.trimmingCharacters(in: .whitespaces),!email.isEmpty, !password.isEmpty
            else{
                alert(title: "Waring", message: "Email and Password should not be empty!")
                updateUI(processing: false)
                return
        }
        
        UdacityAPI.postSession(with: email, password: password) { (result,error)in
            if let error = error {
                self.alert (title: "Error", message: error.localizedDescription)
                self.updateUI(processing: false)
                return
            }
            if let error = result?["error"] as? String {
                self.alert(title: "Error", message: error)
                self.updateUI(processing: false)
                return
            }
            if let session = result?["session"] as? [String:Any], let sessionId = session["id"]
                as? String {
                print(sessionId)
                UdacityAPI.deleteSession{ (error) in
                    if let error = error {
                        self.alert(title: "Error", message: error.localizedDescription)
                        self.updateUI(processing: false)
                        return
                    }
                    self.updateUI(processing: false)
                    DispatchQueue.main.async {
                        self.emailField.text = ""
                        self.passwordField.text = ""
                        self.performSegue(withIdentifier: "showTapVC", sender: self)
                    }
                }
            }
            self.updateUI(processing: false)
        }
    }
    func updateUI(processing: Bool) {
    DispatchQueue.main.async {
    self.emailField.isUserInteractionEnabled = !processing
    self.passwordField.isUserInteractionEnabled = !processing
    self.loginButton.isEnabled = !processing
      }
    }
}
