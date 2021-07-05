//
//  ForgotPasswordViewController.swift
//  FitU
//
//  Created by David Raygoza on 11/4/20.
//  Copyright © 2020 David Raygoza. All rights reserved.
//

import UIKit
import SQLite3
import Foundation


public class Persons {
    var ID2 = [Int32]()
    var firstName2 = [String]()
    var lastName2 = [String]()
    var email2 = [String]()
    var password2 = [String]()
}

var forgotvcPeople = Persons()

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var forgotPasswordVCLogo: UIImageView!
    
    
    @IBOutlet weak var backButton: UIStackView!
    @IBOutlet var fnameO: UITextField!
    @IBOutlet var lnameO: UITextField!
    @IBOutlet var emailO: UITextField!
    @IBOutlet var fnameLabel: UILabel!
    @IBOutlet var lnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet weak var errorHandlingLabel: UILabel!
    
    @IBOutlet var findAccountButtonO: UIButton!
    
    @IBOutlet var updatePasswordO: UIButton!
    
    @IBOutlet weak var errorButtonO: UIButton!
    @IBAction func errorButton(_ sender: Any) {
        guard let createaccountvc = storyboard?.instantiateViewController(identifier: "createaccount_vc") as? CreateAccountViewController else{
            print("couldnt find page")
            return
            }
        createaccountvc.modalPresentationStyle = .fullScreen
        present(createaccountvc, animated: true)
    }
    func verifyAccountInfo(people2: Persons)->Bool{
        var k = 0
        print("Class Counter: \(people2.email2.count)")
        while(k < people2.email2.count){
            if(people2.firstName2[k] == fnameO.text && people2.lastName2[k] == lnameO.text && people2.email2[k] == emailO.text){
                errorHandlingLabel.isHidden = true
                return true
            }else{
                k = k+1
            }
        }
        errorHandlingLabel.isHidden = false
        errorButtonO.isHidden = false
        errorHandlingLabel.text = "Account not Found"
        return false
    }
    
    func inputAccounts2(people2: Persons){
        people2.ID2.removeAll()
        people2.firstName2.removeAll()
        people2.lastName2.removeAll()
        people2.email2.removeAll()
        people2.password2.removeAll()
        
        let queryStatementString2 = "Select * from authorData3"
        var queryStatement2: OpaquePointer?
        if (sqlite3_prepare_v2(db, queryStatementString2, -1, &queryStatement2, nil) == SQLITE_OK) {
//          print("\nQuery Result for authorData3 table:")
//          print("\nId | fname  | lname | username | password")
            while sqlite3_step(queryStatement2) == SQLITE_ROW {
                
                
                
            let id = sqlite3_column_int(queryStatement2, 0)
            guard let queryResultCol1 = sqlite3_column_text(queryStatement2, 1) else {
              print("Query result for col 1 is nil")
              return
            }
            let fname = String(cString: queryResultCol1)
            
            guard let queryResultCol2 = sqlite3_column_text(queryStatement2, 2) else {
              print("Query result for col 2 is nil")
              return
            }
            let lname = String(cString: queryResultCol2)
            // 5
            
            guard let queryResultCol3 = sqlite3_column_text(queryStatement2, 3) else {
              print("Query result for col 3 is nil")
              return
            }
            let username = String(cString: queryResultCol3)
            
                
            guard let queryResultCol4 = sqlite3_column_text(queryStatement2, 4) else {
              print("Query result for col 4 is nil")
              return
            }
            let password = String(cString: queryResultCol4)
                
               
                
               
//            print("\(id) | \(fname) | \(lname) | \(username) | \(password)")
                
                       
                
                        people2.ID2.append(id)
                        people2.firstName2.append(fname)
                        people2.lastName2.append(lname)
                        people2.email2.append(username)
                        people2.password2.append(password)
                    
        }
        }else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement2)
        print("\n\n")
    } //end of func
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    
    @IBAction func findAccountButton(_ sender: Any) {
        inputAccounts2(people2: forgotvcPeople)
        print("Class Counter: \(forgotvcPeople.email2.count)")
        
        var fn = fnameO.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var ln = lnameO.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = emailO.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        fnameLabel.textColor = .darkGray
        lnameLabel.textColor = .darkGray
        emailLabel.textColor = .darkGray
        errorHandlingLabel.isHidden = true
        errorButtonO.isHidden = true
        if(fn == "" || ln == "" || (textFieldValidatorEmail(email!)) == false){
            errorHandlingLabel.isHidden = false
            errorHandlingLabel.text = "Errors Found"
            if(fn == ""){
                print("F name empty")
                fnameLabel.textColor = .red
            }
            
            if(ln == ""){
                print("L name empty")
                lnameLabel.textColor = .red
            }
            
            if((textFieldValidatorEmail(email!)) == false){
                print("Email wrong")
                emailLabel.textColor = .red
            }
            return
        }else{
            if(verifyAccountInfo(people2: forgotvcPeople) == true){
                fnameLabel.text = "New Password"
                lnameLabel.text = "Re-enter password"
                fnameO.text = ""
                lnameO.text = ""
                emailO.isHidden = true
                findAccountButtonO.isHidden = true
                updatePasswordO.isHidden = false
                emailLabel.isHidden = true
                fnameO.isSecureTextEntry = true
                lnameO.isSecureTextEntry = true
                print("Account found")
            }
        }
        
        
        
} // end of find account button click fucntion
    
    @IBAction func updatePasswordButton(_ sender: Any) {
        var email = emailO.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var pass = fnameO.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var pass2 = lnameO.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        fnameLabel.textColor = .darkGray
        lnameLabel.textColor = .darkGray
        if(pass != "" && pass2 != "" && (pass == pass2)) {
            guard let loginvc = storyboard?.instantiateViewController(identifier: "login_vc") as? LoginViewController else{
                print("couldnt find page")
                return
                }
            loginvc.modalPresentationStyle = .fullScreen
            present(loginvc, animated: true)
            
            
            //UPDATE authors SET password ='pass' WHERE email='email';
            var statement: OpaquePointer?
            let insertStatement4 = "UPDATE authorData3 SET password = '\(pass as! NSString)' where username = '\(email as! NSString)';"
            sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
            if sqlite3_step(statement) == SQLITE_DONE{
                print("updated into author")
            }else{
                print("not updated into author ")
            }
            sqlite3_finalize(statement)
        
    }else{
        errorHandlingLabel.isHidden = false
        errorHandlingLabel.text = "Errors Found"
        if(pass == ""){
            fnameLabel.textColor = .red
            print("Password is empty")
            return
        }
        
        if(pass2 == ""){
            lnameLabel.textColor = .red
            print("Password is empty")
            return
        }
        
        if(pass != pass2){
            errorHandlingLabel.text = "Passwords Do Not Match"
            fnameLabel.textColor = .red
            lnameLabel.textColor = .red
            print("Passwords dont match")
            return
        }
        print("Some errors in updating password(s)")
    }
        
} // end of update password button click fucntion
    
    
    @objc func forgotPasswordVCLogoClick(gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil {
                    print("Image Tapped")
                    //Here you can initiate your new ViewController
            }
        guard let loginvc = storyboard?.instantiateViewController(identifier: "login_vc") as? LoginViewController else{
            print("couldnt find page")
            return
            }
        loginvc.modalPresentationStyle = .fullScreen
        present(loginvc, animated:true)
    } // end of func
    
    @objc func backButtonClick2(gesture: UIGestureRecognizer){

                if (gesture.view as? UIImageView) != nil {
                            print("Image Tapped")
                            //Here you can initiate your new ViewController
                    }
            guard let splashvc = storyboard?.instantiateViewController(identifier: "splash_vc") as? SplashViewController else{
                print("couldnt find page")
                return
            }
            splashvc.modalPresentationStyle = .fullScreen
            present(splashvc, animated:true)
            } // end of func for logo

    
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.backButtonClick2(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         forgotPasswordVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.forgotPasswordVCLogoClick(gesture:)))
        forgotPasswordVCLogo.addGestureRecognizer(tapGesture)
        forgotPasswordVCLogo.isUserInteractionEnabled = true
        errorHandlingLabel.isHidden = true
        fnameO.delegate = self
        lnameO.delegate = self
        emailO.delegate = self
        
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
    }
    

   

}
