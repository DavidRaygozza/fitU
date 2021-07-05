import UIKit
import Foundation
import SQLite3

public class Person {
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

var people = Person()
public class rememberingEmail{
    var ID2 = [Int32]()
    var rememberedEmail2 = [String]()
}
var rememberEmailObj = rememberingEmail()

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet var loginEmailField: UITextField!
    @IBOutlet var LoginpasswordField: UITextField!
    @IBOutlet weak var loginFailedFIeld: UILabel!
    
    @IBOutlet weak var createButtonO: UIButton!
    
    
    @IBOutlet weak var forgotButtonO: UIButton!
    @IBOutlet weak var loginButtonO: UIButton!
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        //create remembered email table
        let createRememberEmailTable = "CREATE TABLE IF NOT EXISTS rememberedEmail (id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT);"
           if sqlite3_exec(db, createRememberEmailTable, nil, nil, nil) != SQLITE_OK{
               print ("Error opening rememberedEmail table")
           }
        
        let createfitnessData2table = "CREATE TABLE IF NOT EXISTS fitnessData2 (id INTEGER PRIMARY KEY AUTOINCREMENT, bmr INTEGER, water INTEGER, yourBmr INTEGER, yourWater INTEGER);"
           if sqlite3_exec(db, createfitnessData2table, nil, nil, nil) != SQLITE_OK{
               print ("Error opening fitnessData2 table")
           }
    }
    
    func loggingIn(people2: Person)->Bool{
        var k = 0
        print("Class Counter: \(people2.email2.count)")
        while(k < people2.email2.count){
            if(people2.email2[k] == loginEmailField.text && people2.password2[k] == LoginpasswordField.text){
                UserDefaults.standard.set(true, forKey: "isLoggedIn17")
                UserDefaults.standard.synchronize()
                
                //DELETE PERVIOUS data from table
                let deleteStatement1 = "Delete from rememberedEmail where id >= 0;"
                var ds1: OpaquePointer?
                sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
                if sqlite3_step(ds1) == SQLITE_DONE{
                    print("delete all")
                }else{
                    print("not deleted")
                }
                sqlite3_finalize(ds1)
                
                //insert email into table
                var statement5: OpaquePointer?
                let insertStatement4 = "INSERT into rememberedEmail (email) values ('\(loginEmailField.text as! NSString)');"
                sqlite3_prepare_v2(db, insertStatement4, -1, &statement5, nil)
                if sqlite3_step(statement5) == SQLITE_DONE{
                    print("inserted into rememberedEmail table")
                }else{
                    print("not inserted into rememberedEmail table")
                }
                sqlite3_finalize(statement5)
                
                inputRememberedEmail(rm: rememberEmailObj)
                var index = findfitnessData2Index()
                var bmr:Double = 0.0
                var w = Double(people.weight2[index])
                var h = Double(people.height2[index])
                var a = Double(people.age2[index])
                var ac = people.activity2[index]
                bmr = (10 * (w * 0.453592)) + (6.26 * h) - (5 * a)
                var activityInMinutes = 0
                
                if(Int(ac) == 0){
                    activityInMinutes = 0
                    bmr *= 1.199886
                }else if(Int(ac) == 1){
                    activityInMinutes = 60
                    bmr *= 1.374715
                }else if(Int(ac) == 2){
                    activityInMinutes = 90
                    bmr *= 1.464692
                }else if(Int(ac) == 3){
                    activityInMinutes = 120
                    bmr *= 1.549544
                }else if(Int(ac) == 4){
                    activityInMinutes = 120
                    bmr *= 1.724373
                }else if(Int(ac) == 5){
                    activityInMinutes = 150
                    bmr *= 1.899772
                }
                
                if(people.gender2[index] == "Female"){
                    print("Female selected")
                    bmr = floor(bmr - 161)
                    print("BMR: \(bmr)")
                }else if(people.gender2[index] == "Male"){
                    print("Male selected")
                    bmr = floor(bmr + 5)
                    print("BMR: \(bmr)")
                }
                
                if(String(people2.goal2[index]) == "Shred"){
                    bmr = floor(bmr - 500)
                }else if(String(people2.goal2[index]) == "Bulk"){
                    bmr = floor(bmr + 500)
                }
                
                var water = floor((w * 0.6666) + Double(((activityInMinutes/30) * 12)))
                print("Daily Calories: \(String(bmr))")
              print( "Daily Water: \(String(water))")
                
                let deleteStatement10 = "DELETE from fitnessData2 where id >= 0;"
                var ds10: OpaquePointer?
                sqlite3_prepare_v2(db, deleteStatement10, -1, &ds10, nil)
                if sqlite3_step(ds10) == SQLITE_DONE{
                    print("delete all fitnessData2")
                }else{
                    print("not deleted all fitnessData2")
                }
                sqlite3_finalize(ds10)
                
                var statement14: OpaquePointer?
                let insertStatement14 = "INSERT into fitnessData2 (bmr, water, yourBmr, yourWater) values ('\(bmr)', '\(water)', '0', '0');"
                sqlite3_prepare_v2(db, insertStatement14, -1, &statement14, nil)
                if sqlite3_step(statement14) == SQLITE_DONE{
                    print("inserted into fitnessData2 table")
                }else{
                    print("not inserted into fitnessData2 table")
                }
                return true
            }else{
                k = k+1
            }
        }
        return false
    }
    
    
    func inputRememberedEmail(rm: rememberingEmail){
        rm.ID2.removeAll()
        rm.rememberedEmail2.removeAll()

        let queryStatementString = "Select * from rememberedEmail"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
//            print("\nQuery Result for rememberedEmail:")
//            print("\nId | Email")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = sqlite3_column_int(queryStatement, 0)
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
              print("Query result for col 1 is nil")
              return
            }
            let email = String(cString: queryResultCol1)

            rm.ID2.append(id)
            rm.rememberedEmail2.append(email)


//            print("\(id) | \(email)")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    }
//     end of inout remembered email func
    
  
    
    @IBAction func createAccButton() {
        guard let createaccountvc = storyboard?.instantiateViewController(identifier: "createaccount_vc") as? CreateAccountViewController else{
            print("couldnt find page")
            return
            }
        createaccountvc.modalPresentationStyle = .fullScreen
        present(createaccountvc, animated: true)
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        //forgotpassword_vc
        guard let forgotpasswordvc = storyboard?.instantiateViewController(identifier: "forgotpassword_vc") as? ForgotPasswordViewController else{
            print("couldnt find page")
            return
            }
        forgotpasswordvc.modalPresentationStyle = .fullScreen
        present(forgotpasswordvc, animated:true)
    }
    
    func inputAccounts(people2: Person){
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
    }
    
    //must aslo change isLoggedIn17 on profile page to remmeber sign out
    func rememberLogin()->Bool{
        return UserDefaults.standard.bool(forKey: "isLoggedIn17")
    }
    
    @IBAction func loginButton(_ sender: Any) {
        inputAccounts(people2: people)
        //
        if(loggingIn(people2: people) == true){
            print("Logged in")
            
            guard let mainvc = storyboard?.instantiateViewController(identifier: "main_vc") as? ViewControllerA else{
                print("couldnt find page")
                return
                }
            mainvc.modalPresentationStyle = .fullScreen
            present(mainvc, animated:true)

        }else{
            loginFailedFIeld.isHidden = false
            print("Login account not found")
        }
    } // end of func
    
    
    func findfitnessData2Index()->Int{
        var t = 0
        while(t < people.ID2.count){
            if(people.email2[t] == rememberEmailObj.rememberedEmail2[0]){
                return t
            }else{
                t+=1
            }
        }
        return 0
    }
    
    
    
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        loginEmailField.delegate = self
        LoginpasswordField.delegate = self
        loginFailedFIeld.isHidden = true
        loginButtonO.layer.borderColor = UIColor.white.cgColor
        loginButtonO.layer.borderWidth = 5
        forgotButtonO.layer.borderColor = UIColor.white.cgColor
        forgotButtonO.layer.borderWidth = 5
        createButtonO.layer.borderColor = UIColor.white.cgColor
        createButtonO.layer.borderWidth = 5
    } //end of view did load
} //end of super main class

/*
 SEGUE
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?){
     guard let createAccountVC = segue.destination as? CreateAccountViewController else{
         return
     }
 */
