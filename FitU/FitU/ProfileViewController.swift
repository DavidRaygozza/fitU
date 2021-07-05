import UIKit
import Foundation
import SQLite3

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

public class profileClass {
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

public class rememberingEmailForProfileClass{
    var ID2 = [Int32]()
    var rememberedEmail2 = [String]()
}
var rememberEmailForProfileObj = rememberingEmailForProfileClass()

var profileClassObj = profileClass()

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    var act2  = ["No Exercise", "1-3 times", "4-5 times", "Intense 3-4", "Intense 6-7", "Daily Intense"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return act2.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return act2[row]
    }

    //outlets
    @IBOutlet weak var profileVCLogo: UIImageView!
    @IBOutlet weak var ftField: UITextField!
    @IBOutlet weak var inFIeld: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSliderO: UISlider!
    @IBAction func weightSliderCHange(_ sender: Any) {
        weightLabel.text = "\(Int(floor(Float(weightSliderO.value)))) lbs."
    }
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageSliderO: UISlider!
    
    @IBAction func ageSliderChange(_ sender: Any) {
        ageLabel.text = "\(Int(floor(Float(ageSliderO.value))))"

    }
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var goalClicker: UISegmentedControl!
    @IBOutlet weak var ftLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var backButton: UIImageView!
    
//    func validateFeet(_ string: String)->Bool{
//            if string.count > 1 {
//                return false
//            }
//            let intFormat = "[0-9]{2,64}"
//            let intPredicate = NSPredicate(format:"SELF MATCHES %@", intFormat)
//            return intPredicate.evaluate(with: string)
//        }
    
    @IBAction func updateSettings(_ sender: Any) {
        
        //grabbing new data to insert into table
        var ft = ftField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var inch = inFIeld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var feet:Double
        var inches:Double
        var gender:String = ""
        var activity:String = ""
        var goals:String = ""
        ftLabel.textColor = .darkGray
        inLabel.textColor = .darkGray
        
        if(((ft!.isInt2)==true) && ((inch!.isInt2)==true)){
            feet = (ft! as NSString).doubleValue
            inches = (inch as! NSString).doubleValue
            var height = ((feet * 12) + inches) * 2.54
            var weight = Int(floor(weightSliderO.value))
            var age = Int(floor(ageSliderO.value))
            
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
            print("Is a valid Int")
            var index = findfitnessDataIndexForProfile()
            var bmr:Double = 0.0
            var w = Double(profileClassObj.weight2[index])
            var h = Double(profileClassObj.height2[index])
            var a = Double(profileClassObj.age2[index])
            var ac = profileClassObj.activity2[index]
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
            
            if(profileClassObj.gender2[index] == "Female"){
                print("Female selected")
                bmr = floor(bmr - 161)
                print("BMR: \(bmr)")
            }else if(profileClassObj.gender2[index] == "Male"){
                print("Male selected")
                bmr = floor(bmr + 5)
                print("BMR: \(bmr)")
            }
            
            if(goals == "Lose"){
                bmr = floor(bmr - 500)
            }else if(goals == "Gain"){
                bmr = floor(bmr + 500)
            }
            
            var water = floor((w * 0.6666) + Double(((activityInMinutes/30) * 12)))
            print("Daily Calories: \(String(bmr))")
          print( "Daily Water: \(String(water))")
            
            //fix stateemnt here
            var statement14: OpaquePointer?
            let insertStatement14 = "UPDATE fitnessData2 SET bmr = '\(bmr)', water = '\(water)';"
            sqlite3_prepare_v2(db, insertStatement14, -1, &statement14, nil)
            if sqlite3_step(statement14) == SQLITE_DONE{
                print("inserted into fitnessData2 table")
            }else{
                print("not inserted into fitnessData2 table")
            }
            
            var statement: OpaquePointer?
            let insertStatement4 = "UPDATE authorData3 SET height = '\(height)', weight = '\(weight)', age = '\(age)', activity =  '\(activity as! NSString)', goal = '\(goals as! NSString)' where username = '\(rememberEmailForProfileObj.rememberedEmail2[0] as! NSString)';"
            sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
            if sqlite3_step(statement) == SQLITE_DONE{
                guard let homevc = storyboard?.instantiateViewController(identifier: "home_vc") as? HomeViewController else{
                    print("couldnt find page")
                    return
                    }
                homevc.modalPresentationStyle = .fullScreen
                present(homevc, animated:true)
                print("updated into author")
            }else{
                print("not updated into author ")
            }
            sqlite3_finalize(statement)
            
            ftField.text = ""
            inFIeld.text = ""
            weightLabel.text = "Weight"
            ageLabel.text = "Age"
            weightSliderO.value = 1
            ageSliderO.value = 1
            
            //calculate bmr, and new water, and update into fitness dtaa table
        }else{
            print("Not valid")
            ftLabel.textColor = .red
            inLabel.textColor = .red
        }
    }
    
    func findfitnessDataIndexForProfile()->Int{
        var t = 0
        while(t < profileClassObj.ID2.count){
            if(profileClassObj.email2[t] == rememberEmailForProfileObj.rememberedEmail2[0]){
                return t
            }else{
                t+=1
            }
        }
        return 0
    }
    
    func inputRememberedEmailForProfile(rm: rememberingEmailForProfileClass){
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
    
    func inputAccountsForProfile(people2: profileClass){
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
    
    
    var db: OpaquePointer?
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        
        let createAuthorsTable1 = "CREATE TABLE IF NOT EXISTS authorData3 (id INTEGER PRIMARY KEY AUTOINCREMENT,fname TEXT,lname TEXT,username TEXT,password TEXT, height INTEGER, weight INTEGER, age INTEGER, gender TEXT, activity TEXT, goal TEXT);"
                   if sqlite3_exec(db, createAuthorsTable1, nil, nil, nil) != SQLITE_OK{
                       print ("Error opening authors table")
                    return
            }
        
        let createRememberEmailTable = "CREATE TABLE IF NOT EXISTS rememberedEmail (id INTEGER PRIMARY KEY AUTOINCREMENT,email TEXT);"
           if sqlite3_exec(db, createRememberEmailTable, nil, nil, nil) != SQLITE_OK{
               print ("Error opening rememberedEmail table")
           }
        
        let createfitnessData2table = "CREATE TABLE IF NOT EXISTS fitnessData2 (id INTEGER PRIMARY KEY AUTOINCREMENT, bmr INTEGER, water INTEGER, yourBmr INTEGER, yourWater INTEGER);"
           if sqlite3_exec(db, createfitnessData2table, nil, nil, nil) != SQLITE_OK{
               print ("Error opening fitnessData2 table")
           }
       
    } //end of mai db func
    
    @IBAction func signOutButton(_ sender: Any) {
        UserDefaults.standard.synchronize()
        UserDefaults.standard.set(false, forKey: "isLoggedIn16")
        UserDefaults.standard.synchronize()
        guard let splashvc = storyboard?.instantiateViewController(identifier: "splash_vc") as? SplashViewController else{
            print("couldnt find page")
            return
        }
        splashvc.modalPresentationStyle = .fullScreen
        present(splashvc, animated:true)
    }
    
    @objc func profileVCLogoClick(gesture: UIGestureRecognizer){
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
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.backButtonClick(gesture:)))
        backButton.addGestureRecognizer(tapGesture2)
        backButton.isUserInteractionEnabled = true
        profileVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.profileVCLogoClick(gesture:)))
        profileVCLogo.addGestureRecognizer(tapGesture)
        profileVCLogo.isUserInteractionEnabled = true
        activityPicker.delegate = self
        activityPicker.dataSource = self
        
        //inserting all old data into the fields
        inputRememberedEmailForProfile(rm: rememberEmailForProfileObj)
        inputAccountsForProfile(people2: profileClassObj)
        var index = findfitnessDataIndexForProfile()
        var cmheight = ((profileClassObj.height2[index]) + 1)
        var inchheight:Double = cmheight/(2.54)
        var feetToBeInserted = Int(floor(inchheight / 12))
        print("My feetL \(feetToBeInserted)")
        print("My inches total \(inchheight)")
        var inchesToBeInserted = inchheight - Double((feetToBeInserted * 12))
        ftField.text = "\(Int(feetToBeInserted))"
        inFIeld.text = "\(Int(inchesToBeInserted))"
        weightLabel.text = "\(profileClassObj.weight2[index])"
        weightSliderO.value = Float((profileClassObj.weight2[index]))
        ageSliderO.value = Float((profileClassObj.age2[index]))
        ageLabel.text = "\(Int(profileClassObj.age2[index]))"
        activityPicker.selectRow(Int(profileClassObj.activity2[index]) ?? 0, inComponent: 0, animated: false)
        ftField.delegate = self
        inFIeld.delegate = self
        var intGoal:Int = 0
        if(profileClassObj.goal2[index] == "Lose"){
            intGoal = 0
        }else if(profileClassObj.goal2[index] == "Keep"){
            intGoal = 1
        }else if(profileClassObj.goal2[index] == "Gain"){
            intGoal = 2
        }
        goalClicker.selectedSegmentIndex = intGoal
        
    }//end of veiw did load
} //end of super main class
