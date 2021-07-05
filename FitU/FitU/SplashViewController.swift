//
//  SplashViewController.swift
//  FitU
//
//  Created by Library on 12/12/20.
//  Copyright © 2020 David Raygoza. All rights reserved.
//

import UIKit
import Foundation
import SQLite3

class SplashViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    @IBOutlet weak var backgroundImage: UIImageView!
    
    //outlets
    @IBAction func getStartedButton(_ sender: Any) {
        guard let loginvc = storyboard?.instantiateViewController(identifier: "login_vc") as? LoginViewController else{
            print("couldnt find page")
            return
        }
        loginvc.modalPresentationStyle = .fullScreen
        present(loginvc, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.alpha = 0.60
    }
    


}
