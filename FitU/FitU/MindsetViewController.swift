import UIKit
import Foundation
import SQLite3

public class mindsetDataClass {
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

public class rememberingEmailForMindsetClass{
    var ID2 = [Int32]()
    var rememberedEmail2 = [String]()
}
var rememberingEmailForMindsetObj = rememberingEmailForMindsetClass()
var mindsetDataClassObj = mindsetDataClass()

class MindsetViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    var loseQuotes = ["Intermittent fasting is great for burning fat and building Muscle","Your journey will have many plateaus, shock your body to break it!","Fitness is a process, chisel your way to results", "Determination is key", "Instead of cooking oil use 0 calorie cooking spray"]
    var keepQuotes = ["Fitness is a process","Realx, and try to maintain physique","You can't maintain 100%, jsut try to slow down fat gain", "Do a cut every couple of months to really maintain physique", "You should still drink protein!"]
    var gainQuotes = ["Fitness is a process","Add oils to your meals, extra calories","A lean Bulk is more effective than a dirty one", "Stay focused on the goal", "Don't bulk for too long"]

    @IBOutlet weak var backButton: UIStackView!
    @IBOutlet weak var mindsetVCLogo: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBAction func refreshButton(_ sender: Any) {
        var index = findfitnessDataIndexForMindset()
        getQuote()    }
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @objc func mindsetVCLogoClick(gesture: UIGestureRecognizer){
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
    
    
    func findfitnessDataIndexForMindset()->Int{
        var t = 0
        while(t < mindsetDataClassObj.ID2.count){
            if(mindsetDataClassObj.email2[t] == rememberingEmailForMindsetObj.rememberedEmail2[0]){
                return t
            }else{
                t+=1
            }
        }
        return 0
    }
        
    func inputRememberedEmailForMindset(rm: rememberingEmailForMindsetClass){
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
    } //end of remember email func
    
    func inputAccountsForMindset(people2: mindsetDataClass){
        people2.ID2.removeAll()
//        people2.firstName2.removeAll()
//        people2.lastName2.removeAll()
        people2.email2.removeAll()
//        people2.height2.removeAll()
//        people2.weight2.removeAll()
//        people2.age2.removeAll()
//        people2.gender2.removeAll()
//        people2.activity2.removeAll()
        people.goal2.removeAll()

        
        let queryStatementString2 = "Select * from authorData3"
        var queryStatement2: OpaquePointer?
        if (sqlite3_prepare_v2(db, queryStatementString2, -1, &queryStatement2, nil) == SQLITE_OK) {
//          print("\nQuery Result for authorData3 table:")
//          print("\nId | fname  | lname | username | password | Height | Weight | Age | Gender | Activity | Goal")
//            print("\nId | Username | Goal")

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
    }
    
    @objc func getQuote(){
        var index = findfitnessDataIndexForMindset()
        var randomInt:Int = 0
        if(mindsetDataClassObj.goal2[index] == "Lose"){
            randomInt = Int.random(in: 0..<loseQuotes.count)
            UILabel.transition(with: quoteLabel, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in self?.quoteLabel.text = "\(self!.loseQuotes[randomInt])"}, completion: nil)
        }else if(mindsetDataClassObj.goal2[index] == "Keep"){
            randomInt = Int.random(in: 0..<keepQuotes.count)
            UILabel.transition(with: quoteLabel, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in self?.quoteLabel.text = "\(self!.keepQuotes[randomInt])"}, completion: nil)
        }else if(mindsetDataClassObj.goal2[index] == "Gain"){
            randomInt = Int.random(in: 0..<gainQuotes.count)
            UILabel.transition(with: quoteLabel, duration: 1, options: .transitionCrossDissolve, animations: { [weak self] in self?.quoteLabel.text = "\(self!.gainQuotes[randomInt])"}, completion: nil)
        }
        print("Random #: \(randomInt)")
    } //end of if else
    
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
    
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(MindsetViewController.backButtonClick(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         mindsetVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        backgroundImage.alpha = 0.60
        inputRememberedEmailForMindset(rm: rememberingEmailForMindsetObj)
        inputAccountsForMindset(people2: mindsetDataClassObj)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MindsetViewController.mindsetVCLogoClick(gesture:)))
        mindsetVCLogo.addGestureRecognizer(tapGesture)
        mindsetVCLogo.isUserInteractionEnabled = true
        getQuote()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.getQuote), userInfo: nil, repeats: true)
    }

}
