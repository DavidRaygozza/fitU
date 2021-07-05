import UIKit
import Foundation
import SQLite3

extension String {
    var isInt2: Bool {
        return Int(self) != nil
    }
}

public class PersonCreationClass {
    var ID2 = [Int32]()
    var firstName2 = [String]()
    var lastName2 = [String]()
    var email2 = [String]()
    var password2 = [String]()
    var height2 = [Double]()
    var weight2 = [Int32]()
    var age2 = [Int32]()
    var gender2 = [String]()
    var activity2 = [String]()
    var goal2 = [String]()
}

var PersonCreationObj = PersonCreationClass()

class CreateAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var act  = ["No Exercise", "1-3 times", "4-5 times", "Intense 3-4", "Intense 6-7", "Daily Intense"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return act.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return act[row]
    }
    
    //might use later to determine if account email being used is repeated
    var repeated:Bool = false
    
    //personal info outlets
    @IBOutlet weak var createAccountVCLogo: UIImageView!
    @IBOutlet var fnameField: UITextField!
    @IBOutlet var lnameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet weak var fnameStack: UIStackView!
    @IBOutlet weak var lnameStack: UIStackView!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var backButton: UIStackView!
    
    
    //fitness data outlets
    @IBOutlet weak var heightStack: UIStackView!
    @IBOutlet weak var weightStack: UIStackView!
    @IBOutlet weak var ageStack: UIStackView!
    @IBOutlet weak var genderStack: UIStackView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var ftField: UITextField!
    @IBOutlet weak var inField: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSliderO: UISlider!
    @IBAction func weightSliderChange(_ sender: Any) {
        weightLabel.text = "\(Int(floor(Float(weightSliderO.value)))) lbs."
    }
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageSliderO: UISlider!
    @IBAction func ageSliderChange(_ sender: Any) {
        ageLabel.text = "\(Int(floor(Float(ageSliderO.value))))"
    }
    @IBOutlet weak var activityStack: UIStackView!
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var goalStack: UIStackView!
    
    @IBOutlet weak var goalClicker: UISegmentedControl!
    @IBOutlet weak var genderClicker: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var ftLabel: UILabel!
    @IBOutlet weak var errorButtonO: UIButton!
    
    @IBOutlet weak var inLabel: UILabel!
    @IBAction func errorButton(_ sender: Any) {
        guard let forgotpasswordvc = storyboard?.instantiateViewController(identifier: "forgotpassword_vc") as? ForgotPasswordViewController else{
            print("couldnt find page")
            return
            }
        forgotpasswordvc.modalPresentationStyle = .fullScreen
        present(forgotpasswordvc, animated:true)
    }
    @IBOutlet weak var fNameLabel: UILabel!
    @IBOutlet weak var lNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    
    var db: OpaquePointer?
    func inputAccountsForCreation(people2: PersonCreationClass){
        people2.ID2.removeAll()
        people2.firstName2.removeAll()
        people2.lastName2.removeAll()
        people2.email2.removeAll()
        people2.height2.removeAll()
        people2.weight2.removeAll()
        people2.age2.removeAll()
        people2.gender2.removeAll()
        people2.activity2.removeAll()
        people.goal2.removeAll()

        
        let queryStatementString2 = "Select * from authorData3"
        var queryStatement2: OpaquePointer?
        if (sqlite3_prepare_v2(db, queryStatementString2, -1, &queryStatement2, nil) == SQLITE_OK) {
//          print("\nQuery Result for authorData3 table:")
//          print("\nId | fname  | lname | username | password | Height | Weight | Age | Gender | Activity | Goal")
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
                let height = sqlite3_column_int(queryStatement2, 5)
                let weight = sqlite3_column_int(queryStatement2, 6)
                let age = sqlite3_column_int(queryStatement2, 7)

                guard let queryResultCol8 = sqlite3_column_text(queryStatement2, 8) else {
                  print("Query result for col 8 is nil")
                  return
                }
                let gender = String(cString: queryResultCol8)
                guard let queryResultCol9 = sqlite3_column_text(queryStatement2, 9) else {
                  print("Query result for col 9 is nil")
                  return
                }
                let activity = String(cString: queryResultCol9)
                
                guard let queryResultCol10 = sqlite3_column_text(queryStatement2, 10) else {
                  print("Query result for col 10 is nil")
                  return
                }
                let goal = String(cString: queryResultCol10)
               
//            print("\(id) | \(fname) | \(lname) | \(username) | \(password) | \(height) | \(weight) | \(age) | \(gender) | \(activity) | \(goal)")
                        people2.ID2.append(id)
                        people2.firstName2.append(fname)
                        people2.lastName2.append(lname)
                        people2.email2.append(username)
                        people2.password2.append(password)
                        people2.height2.append(Double(height))
                        people2.weight2.append(weight)
                        people2.age2.append(age)
                        people2.gender2.append(gender)
                        people2.activity2.append(activity)
                        people2.goal2.append(goal)

        }
        }else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement2)
        
        print("\n\n")
    } //end of func
    
    func findIfExists(emailParam:String)->Bool{
        var g = 0
        while(g < PersonCreationObj.ID2.count){
            if(PersonCreationObj.email2[g] == emailParam){
                print("Email already exists")
                return true
            }else{
                g += 1
            }
        }
        print("Email didnt exist")
        return false
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }

    @IBAction func continueButton(_ sender: Any) {
        var fn = fnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var ln = lnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var pass = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(textFieldValidatorEmail(email!)){
            print ("Email is formatted correctly")
        }else{
            print ("Email not formatted correctly")
        }
        fNameLabel.textColor = .darkGray
        lNameLabel.textColor = .darkGray
        passwordLabel.textColor = .darkGray
        emailLabel.textColor = .darkGray
        errorLabel.isHidden = true
        errorButtonO.isHidden = true
        
        if((fn != "") && (ln != "") && (pass != "") && textFieldValidatorEmail(email!) == true && findIfExists(emailParam: email!) == false) {
           
            fnameStack.isHidden = true
            lnameStack.isHidden = true
            emailStack.isHidden = true
            passwordStack.isHidden = true
            continueButtonOutlet.isHidden = true
            heightStack.isHidden = false
            weightStack.isHidden = false
            ageStack.isHidden = false
            genderStack.isHidden = false
            activityStack.isHidden = false
            goalStack.isHidden = false
            createButton.isHidden = false
        }else{
            errorLabel.isHidden = false
            if(fn == ""){
                print("Error was in first name")
                errorLabel.text = "Errors Found"
                fNameLabel.textColor = .red
                errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

            }
            if(ln == ""){
                print("Error was in last name")
                errorLabel.text = "Errors Found"
                lNameLabel.textColor = .red
                errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            }
            if(pass == ""){
                print("Error was in password")
                errorLabel.text = "Errors Found"
                passwordLabel.textColor = .red
                errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            }
            if(email == "" || textFieldValidatorEmail(email!) == false){
                print("Error was in email")
                errorLabel.text = "Errors Found"
                emailLabel.textColor = .red
                errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            }

            if((findIfExists(emailParam:email!) == true)){
                print("Error was in account exists")
                errorButtonO.isHidden = false
                errorLabel.text = "Email already exists"
                emailLabel.textColor = .red
            }
            
            //create function to find if email is already in use
            print("There was an error with personal data entry")
        }
    } // end of continue button func
    
        
    @IBAction func createButtonClick(_ sender: Any) {
        ftLabel.textColor = .darkGray
        inLabel.textColor = .darkGray
        var fn = fnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var ln = lnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var pass = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var ft = ftField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var inch = inField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var feet:Double
        var inches:Double
        var gender:String = ""
        var activity:String = ""
        var goals:String = ""
//        if(inch?.isEmpty)!{
//            print("inches is empty")
//            return
//        }
//
//        if(ft?.isEmpty)!{
//            print("Feet is empty")
//            return
//        }
//
        if(((ft!.isInt2)==true) && ((inch!.isInt2)==true)){
            print("No errors found")
            feet = (ft as! NSString).doubleValue
            inches = (inch as! NSString).doubleValue
            var weight = Int(floor(weightSliderO.value))
            var age = Int(floor(ageSliderO.value))
            var height = ((feet * 12) + inches) * 2.54
            if(genderClicker.selectedSegmentIndex == 0){
                gender = "Female"
            }else if(genderClicker.selectedSegmentIndex == 1){
                gender = "Male"
            }
            
            activity = activityPicker.selectedRow(inComponent: 0).description
            print("Activity: \(activity)")
            if(goalClicker.selectedSegmentIndex == 0){
                goals = "Lose"
            }else if(goalClicker.selectedSegmentIndex == 1){
                goals = "Keep"
            }else if(goalClicker.selectedSegmentIndex == 2){
                goals = "Gain"
            }
            print("Goal: \(goals)")
            var statement3: OpaquePointer?
            let insertStatement4 = "INSERT into authorData3 (fname, lname, username, password, height, weight, age, gender, activity, goal) values ('\(fn as! NSString)', '\(ln as! NSString)', '\(email as! NSString)', '\(pass as! NSString)','\(height)', '\(weight)', '\(age)', '\(gender as! NSString)', '\(activity as! NSString)', '\(goals as! NSString)');"
            sqlite3_prepare_v2(db, insertStatement4, -1, &statement3, nil)
            if sqlite3_step(statement3) == SQLITE_DONE{
                guard let loginvc = storyboard?.instantiateViewController(identifier: "login_vc") as? LoginViewController else{
                    print("couldnt find page")
                    return
                    }
                loginvc.modalPresentationStyle = .fullScreen
                present(loginvc, animated: true)
                print("inserted into authors")
            }else{
                print("not inserted into authors")
            }
            sqlite3_finalize(statement3)

            fnameField.text = "";
            lnameField.text = ""
            emailField.text = ""
            passwordField.text = ""
            ftField.text = ""
            inField.text = ""
            weightLabel.text = "Weight"
            ageLabel.text = "Age"
            weightSliderO.value = 1
            ageSliderO.value = 1
        }else{
            print("Errors found")
            ftLabel.textColor = .red
            inLabel.textColor = .red
        }
    }
    
    @objc func createAccountVCLogoClick(gesture: UIGestureRecognizer){
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
    
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        
        let createAuthorsTable1 = "CREATE TABLE IF NOT EXISTS authorData3 (id INTEGER PRIMARY KEY AUTOINCREMENT,fname TEXT,lname TEXT,username TEXT,password TEXT, height DOUBLE, weight INTEGER, age INTEGER, gender TEXT, activity TEXT, goal TEXT);"
       if sqlite3_exec(db, createAuthorsTable1, nil, nil, nil) != SQLITE_OK{
           print ("Error opening authors table")
        return
        }
    } // end pof func
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.backButtonClick2(gesture:)))
        backButton.addGestureRecognizer(tapGesture2)
        backButton.isUserInteractionEnabled = true
 createAccountVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        activityPicker.dataSource = self
        activityPicker.delegate = self
        fnameField.delegate = self
        lnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        ftField.delegate = self
        inField.delegate = self
        fnameField.delegate = self
        mainDBInfo()
        inputAccountsForCreation(people2: PersonCreationObj)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.createAccountVCLogoClick(gesture:)))
        createAccountVCLogo.addGestureRecognizer(tapGesture)
        createAccountVCLogo.isUserInteractionEnabled = true
        
        
    } // end of view did load
    
} // end of main super class
