import UIKit
import Foundation
import SQLite3
public class accountInfoForExerciseVCClass {
    var ID2 = [Int32]()
//    var firstName2 = [String]()
//    var lastName2 = [String]()
    var email2 = [String]()
//    var password2 = [String]()
//    var height2 = [Double]()
//    var weight2 = [Int32]()
//    var age2 = [Int32]()
//    var gender2 = [String]()
//    var activity2 = [String]()
    var goal2 = [String]()
}

public class rememberingEmailForExerciseClass{
    var ID2 = [Int32]()
    var rememberedEmail2 = [String]()
}
var accountInfoForExerciseVCObj = accountInfoForExerciseVCClass()
var rememberingEmailForExerciseObj = rememberingEmailForExerciseClass()

class ExerciseViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    @IBOutlet weak var stack1NameLabel: UILabel!
    @IBOutlet weak var stack2NameLabel: UILabel!
    @IBOutlet weak var stack3NameLabel: UILabel!
    @IBOutlet weak var stack4NameLabel: UILabel!
    @IBOutlet weak var stack5NameLabel: UILabel!
    @IBOutlet weak var stack6NameLabel: UILabel!
    @IBOutlet weak var stack7NameLabel: UILabel!
    @IBOutlet weak var stack8NameLabel: UILabel!

    @IBOutlet weak var exerciseVCLogo: UIImageView!
    //outlet stakcs thta need borders
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    @IBOutlet weak var stackView6: UIStackView!
    @IBOutlet weak var stackView8: UIStackView!
    @IBOutlet weak var stackView7: UIStackView!
    @IBOutlet weak var stack1SetLabel: UILabel!

    @IBOutlet weak var backButton: UIStackView!
    


    @IBOutlet weak var stack1RepLabel: UILabel!
    
    @IBOutlet weak var stack3SetLabel: UILabel!
    @IBOutlet weak var stack3RepLabel: UILabel!
    @IBOutlet weak var stack2SetLabel: UILabel!
    @IBOutlet weak var stack2RepLabel: UILabel!
    
    @IBOutlet weak var stack4SetLabel: UILabel!
    @IBOutlet weak var stack4RepLabel: UILabel!
    
    @IBOutlet weak var stack5SetLabel: UILabel!
    @IBOutlet weak var stack5RepLabel: UILabel!
    
    @IBOutlet weak var stack6SetLabel: UILabel!
    @IBOutlet weak var stack6RepLabel: UILabel!
    
    @IBOutlet weak var stack7SetLabel: UILabel!
    @IBOutlet weak var stack7RepLabel: UILabel!
    
    @IBOutlet weak var stack8SetLabel: UILabel!
    @IBOutlet weak var stack8RepLabel: UILabel!
    
    @IBOutlet weak var dataLabel1: UILabel!
    @IBOutlet weak var dataLabel2: UILabel!
    @IBOutlet weak var dataLabel3: UILabel!
    @IBOutlet weak var dataLabel4: UILabel!
    @IBOutlet weak var dataLabel5: UILabel!
    @IBOutlet weak var dataLabel6: UILabel!
    @IBOutlet weak var dataLabel7: UILabel!
    @IBOutlet weak var dataLabel8: UILabel!
    
    @IBOutlet weak var personalListButtonO: UIButton!
    
    //functiomns
    
    func findfitnessDataIndexForMindset()->Int{
        var t = 0
        while(t < accountInfoForExerciseVCObj.ID2.count){
            if(accountInfoForExerciseVCObj.email2[t] == rememberingEmailForExerciseObj.rememberedEmail2[0]){
                return t
            }else{
                t+=1
            }
        }
        return 0
    }
    
    func inputRememberedEmailForExerciseVC(rm: rememberingEmailForExerciseClass){
        rm.ID2.removeAll()
        rm.rememberedEmail2.removeAll()

        let queryStatementString = "Select * from rememberedEmail"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            print("\nQuery Result for rememberedEmail:")
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
    } //end of remember email func
    
    func inputAccountsForExerciseVC(people2: accountInfoForExerciseVCClass){
        people2.ID2.removeAll()
//        people2.firstName2.removeAll()
//        people2.lastName2.removeAll()
        people2.email2.removeAll()
//        people2.height2.removeAll()
//        people2.weight2.removeAll()
//        people2.age2.removeAll()
//        people2.gender2.removeAll()
//        people2.activity2.removeAll()
        people2.goal2.removeAll()

        
        let queryStatementString2 = "Select * from authorData3"
        var queryStatement2: OpaquePointer?
        if (sqlite3_prepare_v2(db, queryStatementString2, -1, &queryStatement2, nil) == SQLITE_OK) {
          print("\nQuery Result for authorData3 table:")
//          print("\nId | fname  | lname | username | password | Height | Weight | Age | Gender | Activity | Goal")
            print("\nId | Username | Goal")

            while sqlite3_step(queryStatement2) == SQLITE_ROW {
                
                
                
            let id = sqlite3_column_int(queryStatement2, 0)
//            guard let queryResultCol1 = sqlite3_column_text(queryStatement2, 1) else {
//              print("Query result for col 1 is nil")
//              return
//            }
//            let fname = String(cString: queryResultCol1)
//
//            guard let queryResultCol2 = sqlite3_column_text(queryStatement2, 2) else {
//              print("Query result for col 2 is nil")
//              return
//            }
//            let lname = String(cString: queryResultCol2)
//            // 5
//
            guard let queryResultCol3 = sqlite3_column_text(queryStatement2, 3) else {
              print("Query result for col 3 is nil")
              return
            }
            let username = String(cString: queryResultCol3)
//
//
//            guard let queryResultCol4 = sqlite3_column_text(queryStatement2, 4) else {
//              print("Query result for col 4 is nil")
//              return
//            }
//            let password = String(cString: queryResultCol4)
//                let height = sqlite3_column_int(queryStatement2, 5)
//                let weight = sqlite3_column_int(queryStatement2, 6)
//                let age = sqlite3_column_int(queryStatement2, 7)
//
//                guard let queryResultCol8 = sqlite3_column_text(queryStatement2, 8) else {
//                  print("Query result for col 8 is nil")
//                  return
//                }
//                let gender = String(cString: queryResultCol8)
//                guard let queryResultCol9 = sqlite3_column_text(queryStatement2, 9) else {
//                  print("Query result for col 9 is nil")
//                  return
//                }
//                let activity = String(cString: queryResultCol9)
                
                guard let queryResultCol10 = sqlite3_column_text(queryStatement2, 10) else {
                  print("Query result for col 10 is nil")
                  return
                }
                let goal = String(cString: queryResultCol10)
               
//            print("\(id) | \(fname) | \(lname) | \(username) | \(password) | \(height) | \(weight) | \(age) | \(gender) | \(activity) | \(goal)")
//                print("\(id) | \(username) | \(goal)")
                        people2.ID2.append(id)
//                        people2.firstName2.append(fname)
//                        people2.lastName2.append(lname)
                        people2.email2.append(username)
//                        people2.password2.append(password)
//                        people2.height2.append(Double(height))
//                        people2.weight2.append(weight)
//                        people2.age2.append(age)
//                        people2.gender2.append(gender)
//                        people2.activity2.append(activity)
                        people2.goal2.append(goal)

        }
        }else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement2)
        
        print("\n\n")
    }
    
    
    @IBAction func viewPersonalWorkoutList(_ sender: Any) {
        openPersonalExerciseList()
    }
    
    func openPersonalExerciseList(){
        guard let userexercisevc = storyboard?.instantiateViewController(identifier: "userExercise_vc") as? userExerciseViewController else{
            print("couldnt find page")
            return
            }
        userexercisevc.modalPresentationStyle = .fullScreen
        present(userexercisevc, animated: true)
    }
    
    var db: OpaquePointer?
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS userExerciseTable2 (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sets INTEGER, reps INTEGER, type TEXT);"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print ("Error opening table")
            return
        }
        
        let createAuthorsTable1 = "CREATE TABLE IF NOT EXISTS authorData3 (id INTEGER PRIMARY KEY AUTOINCREMENT,fname TEXT,lname TEXT,username TEXT,password TEXT, height DOUBLE, weight INTEGER, age INTEGER, gender TEXT, activity TEXT, goal TEXT);"
       if sqlite3_exec(db, createAuthorsTable1, nil, nil, nil) != SQLITE_OK{
           print ("Error opening authors table")
        return
        }
    } //end of main db info
    
    func insertIntoUserList(n: UILabel, s2: UILabel, r2: UILabel, t2: UILabel){
        var name = String((n.text)!)
        var s = String((s2.text)!)
        var r = String((r2.text)!)
        var t = Int((t2.text)!)
        var type:String = ""
        if(t == 0){
            type = "0"
        }else if(t == 1){
            type = "1"
        }else if(t == 2){
            type = "2"
        }else if(t == 3){
            type = "3"
        }else if(t == 4){
            type = "4"
        }
        var s3 = s.replacingOccurrences(of: "Sets: ", with: "")
        var r3 = r.replacingOccurrences(of: "Reps: ", with: "")
        print("prior sets: \(s3)")
        print("prior reps: \(r3)")

        var sets = Int(s3)
        var reps = Int(r3)
        print("Name: \(name)")
        print("Sets: \(sets)")
        print("reps: \(reps)")
        print("type: \(type)")

        var statement4: OpaquePointer?
        let insertStatement4 = "INSERT into userExerciseTable2 (name, sets, reps, type) values ('\(name as! NSString)', '\(s3)', '\(r3)', '\(type  as! NSString)');"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement4, nil)
        if sqlite3_step(statement4) == SQLITE_DONE{
            print("inserted into user exercise table")
            openPersonalExerciseList()
        }else{
            print("not inserted into user exercise table")
        }
    }
   
    
    func makeClickableItems(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.exerciseVCLogoClick(gesture:)))
        exerciseVCLogo.addGestureRecognizer(tapGesture)
        exerciseVCLogo.isUserInteractionEnabled = true
        
        let stackGesture1 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack1Click(gesture:)))
        stackView1.addGestureRecognizer(stackGesture1)
        stackView1.isUserInteractionEnabled = true
        
        let stackGesture2 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack2Click(gesture:)))
        stackView2.addGestureRecognizer(stackGesture2)
        stackView2.isUserInteractionEnabled = true
        
        let stackGesture3 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack3Click(gesture:)))
        stackView3.addGestureRecognizer(stackGesture3)
        stackView3.isUserInteractionEnabled = true
        
        let stackGesture4 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack4Click(gesture:)))
        stackView4.addGestureRecognizer(stackGesture4)
        stackView4.isUserInteractionEnabled = true
        
        let stackGesture5 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack5Click(gesture:)))
        stackView5.addGestureRecognizer(stackGesture5)
        stackView5.isUserInteractionEnabled = true
        
        let stackGesture6 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack6Click(gesture:)))
        stackView6.addGestureRecognizer(stackGesture6)
        stackView6.isUserInteractionEnabled = true
        
        let stackGesture7 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack7Click(gesture:)))
        stackView7.addGestureRecognizer(stackGesture7)
        stackView7.isUserInteractionEnabled = true
        
        let stackGesture8 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.stack8Click(gesture:)))
        stackView8.addGestureRecognizer(stackGesture8)
        stackView8.isUserInteractionEnabled = true
    }
    
    @objc func backButtonClick(gesture: UIGestureRecognizer){

            if (gesture.view as? UIImageView) != nil {
                        print("Image Tapped")
                        //Here you can initiate your new ViewController
                }
            guard let mainvc = storyboard?.instantiateViewController(identifier: "main_vc") as? ViewControllerA else{
            print("couldnt find page")
            return
            }
        mainvc.modalPresentationStyle = .fullScreen
        present(mainvc, animated:true)
        } // end of func for logo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ExerciseViewController.backButtonClick(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         exerciseVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        personalListButtonO.layer.borderWidth = 15
        personalListButtonO.layer.borderColor = UIColor.white.cgColor
        inputAccountsForExerciseVC(people2: accountInfoForExerciseVCObj)
        inputRememberedEmailForExerciseVC(rm: rememberingEmailForExerciseObj)
        var index = findfitnessDataIndexForMindset()
        
        //make all outlets for sets, reps labels at the top
        if(accountInfoForExerciseVCObj.goal2[index] == "Lose"){
            stack1SetLabel.text = "Sets: 2"
            stack1RepLabel.text = "Reps: 50"
            stack2SetLabel.text = "Sets: 2"
            stack2RepLabel.text = "Reps: 50"
            stack3SetLabel.text = "Sets: 3"
            stack3RepLabel.text = "Reps: 15"
            stack4SetLabel.text = "Sets: 3"
            stack4RepLabel.text = "Reps: 15"
            stack5SetLabel.text = "Sets: 2"
            stack5RepLabel.text = "Reps: 25"
            stack6SetLabel.text = "Sets: 3"
            stack6RepLabel.text = "Reps: 15"
            stack7SetLabel.text = "Sets: 3"
            stack7RepLabel.text = "Reps: 8"
            stack8SetLabel.text = "Sets: 3"
            stack8RepLabel.text = "Reps: 10"
        }else if(accountInfoForExerciseVCObj.goal2[index] == "Keep"){
            stack1SetLabel.text = "Sets: 2"
            stack1RepLabel.text = "Reps: 25"
            stack2SetLabel.text = "Sets: 2"
            stack2RepLabel.text = "Reps: 25"
            stack3SetLabel.text = "Sets: 2"
            stack3RepLabel.text = "Reps: 15"
            stack4SetLabel.text = "Sets: 2"
            stack4RepLabel.text = "Reps: 25"
            stack5SetLabel.text = "Sets: 2"
            stack5RepLabel.text = "Reps: 15"
            stack6SetLabel.text = "Sets: 2"
            stack6RepLabel.text = "Reps: 10"
            stack7SetLabel.text = "Sets: 2"
            stack7RepLabel.text = "Reps: 8"
            stack8SetLabel.text = "Sets: 2"
            stack8RepLabel.text = "Reps: 10"
        }else if(accountInfoForExerciseVCObj.goal2[index] == "Gain"){
            stack1SetLabel.text = "Sets: 3"
            stack1RepLabel.text = "Reps: 50"
            stack2SetLabel.text = "Sets: 3"
            stack2RepLabel.text = "Reps: 50"
            stack3SetLabel.text = "Sets: 3"
            stack3RepLabel.text = "Reps: 10"
            stack4SetLabel.text = "Sets: 3"
            stack4RepLabel.text = "Reps: 6"
            stack5SetLabel.text = "Sets: 3"
            stack5RepLabel.text = "Reps: 6"
            stack6SetLabel.text = "Sets: 3"
            stack6RepLabel.text = "Reps: 6"
            stack7SetLabel.text = "Sets: 3"
            stack7RepLabel.text = "Reps: 6"
            stack8SetLabel.text = "Sets: 3"
            stack8RepLabel.text = "Reps: 6"
        }
        
        stackView1.layer.borderWidth = 1
        stackView1.layer.borderColor = UIColor.systemOrange.cgColor
        stackView2.layer.borderWidth = 1
        stackView2.layer.borderColor = UIColor.systemOrange.cgColor
        stackView3.layer.borderWidth = 1
        stackView3.layer.borderColor = UIColor.systemOrange.cgColor
        stackView4.layer.borderWidth = 1
        stackView4.layer.borderColor = UIColor.systemOrange.cgColor
        stackView5.layer.borderWidth = 1
        stackView5.layer.borderColor = UIColor.systemOrange.cgColor
        stackView6.layer.borderWidth = 1
        stackView6.layer.borderColor = UIColor.systemOrange.cgColor
        stackView7.layer.borderWidth = 1
        stackView7.layer.borderColor = UIColor.systemOrange.cgColor
        stackView8.layer.borderWidth = 1
        stackView8.layer.borderColor = UIColor.systemOrange.cgColor
        makeClickableItems()
    } //end of view did load
    
    
    
    //clicking functions
    @objc func exerciseVCLogoClick(gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil {
                    print("Image Tapped")
                    //Here you can initiate your new ViewController
            }
        guard let mainvc = storyboard?.instantiateViewController(identifier: "main_vc") as? ViewControllerA else{
        print("couldnt find page")
        return
        }
    mainvc.modalPresentationStyle = .fullScreen
    present(mainvc, animated:true)
    } // end of func
    
    @objc func stack1Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack1NameLabel, s2: stack1SetLabel, r2: stack1RepLabel, t2: dataLabel1)
        
    } // end of func
    
    @objc func stack2Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack2NameLabel, s2: stack2SetLabel, r2: stack2RepLabel, t2: dataLabel2)

    } // end of func
    
    @objc func stack3Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack3NameLabel, s2: stack3SetLabel, r2: stack3RepLabel, t2: dataLabel3)

    } // end of func
    
    @objc func stack4Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack4NameLabel, s2: stack4SetLabel, r2: stack4RepLabel, t2: dataLabel4)
    } // end of func
    
    @objc func stack5Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack5NameLabel, s2: stack5SetLabel, r2: stack5RepLabel, t2: dataLabel5)
    } // end of func
    
    @objc func stack6Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack6NameLabel, s2: stack6SetLabel, r2: stack6RepLabel, t2: dataLabel6)
    } // end of func
    
    @objc func stack7Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack7NameLabel, s2: stack7SetLabel, r2: stack7RepLabel, t2: dataLabel7)
    } // end of func
    
    @objc func stack8Click(gesture: UIGestureRecognizer){
        insertIntoUserList(n: stack8NameLabel, s2: stack8SetLabel, r2: stack8RepLabel, t2: dataLabel8)
    } // end of func
} //end of super mian class
