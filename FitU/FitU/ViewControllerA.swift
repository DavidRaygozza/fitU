import UIKit
import SQLite3
import Foundation;

class ViewControllerA: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var homeButtonO: UIButton!
    @IBOutlet weak var WaterButtonO: UIButton!
    @IBOutlet weak var DietButtonO: UIButton!
    @IBOutlet weak var ExerciseButtonO: UIButton!
    @IBOutlet weak var MindsetButtonO: UIButton!
    @IBOutlet weak var profileButton: UIImageView!
    
    @IBOutlet weak var mainVCLogo: UIImageView!
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    var logvc = LoginViewController()

    @IBAction func homeButton() {
        guard let homevc = storyboard?.instantiateViewController(identifier: "home_vc") as? HomeViewController else{
            print("couldnt find page")
            return
            }
        homevc.modalPresentationStyle = .fullScreen
        present(homevc, animated: true)
    }
    
    @IBAction func button2() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new_vc") as? NewViewController else{
            print("couldnt find page")
            return
            }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func dietButton() {
        guard let dietvc = storyboard?.instantiateViewController(identifier: "diet_vc") as? DietViewController else{
            print("couldnt find page")
            return
            }
        dietvc.modalPresentationStyle = .fullScreen
        present(dietvc, animated: true)
    }
    
    
    @IBAction func exerciseButton() {
        guard let exercisevc = storyboard?.instantiateViewController(identifier: "exercise_vc") as? ExerciseViewController else{
            print("couldnt find page")
            return
            }
        exercisevc.modalPresentationStyle = .fullScreen
        present(exercisevc, animated: true)
    }
    
    
    @IBAction func mindsetButton() {
        guard let mindsetvc = storyboard?.instantiateViewController(identifier: "mindset_vc") as? MindsetViewController else{
            print("couldnt find page")
            return
            }
        mindsetvc.modalPresentationStyle = .fullScreen
        present(mindsetvc, animated: true)
    }
    
    @IBAction func sleepButton() {
       
        
            guard let sleepvc = storyboard?.instantiateViewController(identifier: "sleep_vc") as? SleepViewController else{
                print("couldnt find page")
                return
                }
        sleepvc.modalPresentationStyle = .fullScreen
            present(sleepvc, animated: true)
    }
    
    
    @objc func showLoginController(){
        guard let splashvc = storyboard?.instantiateViewController(identifier: "splash_vc") as? SplashViewController else{
            print("couldnt find page")
            return
        }
        splashvc.modalPresentationStyle = .fullScreen
        present(splashvc, animated:true)
    }
    
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        if(logvc.rememberLogin() != true){
            print("Did not remember log in from main page")
            perform(#selector(showLoginController), with: nil, afterDelay: 0.0000001)
        }else{
            print("Login was remembered, so main page stayed")
        } //end of remembering login
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ViewControllerA.profilePageButtonClick(gesture:)))
        mainVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileButton.addGestureRecognizer(tapGesture2)
        profileButton.isUserInteractionEnabled = true
        homeButtonO.layer.borderColor = UIColor.white.cgColor
        homeButtonO.layer.borderWidth = 5
        WaterButtonO.layer.borderColor = UIColor.white.cgColor
        WaterButtonO.layer.borderWidth = 5
        DietButtonO.layer.borderColor = UIColor.white.cgColor
        DietButtonO.layer.borderWidth = 5
        ExerciseButtonO.layer.borderColor = UIColor.white.cgColor
        ExerciseButtonO.layer.borderWidth = 5
        MindsetButtonO.layer.borderColor = UIColor.white.cgColor
        MindsetButtonO.layer.borderWidth = 5
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        
        
    }//end of view did load
    
    @objc func profilePageButtonClick(gesture: UIGestureRecognizer){
        if (gesture.view as? UIImageView) != nil {
                    print("Profile button Tapped")
                    //Here you can initiate your new ViewController
            }
        guard let profilevc = storyboard?.instantiateViewController(identifier: "profile_vc") as? ProfileViewController else{
        print("couldnt find page")
        return
        }
        profilevc.modalPresentationStyle = .fullScreen
    present(profilevc, animated:true)
    } // end of func for profile
    
} // end of super main class




/*
 INSERT STATEMENTS
 
 var statement: OpaquePointer?
 let insertStatement = "INSERT into workouts (name, difficulty) values ('90-90 Stretch',2);"
 sqlite3_prepare_v2(db, insertStatement, -1, &statement, nil)
 if sqlite3_step(statement) == SQLITE_DONE{
     print("inserted into workouts")
 }else{
     print("not inserted into wokrouts ")
 }
 sqlite3_finalize(statement)
 
 

 
 var statement2: OpaquePointer?
 let insertStatement2 = "INSERT into author10 (fname, lname, username, password) values ('Chloe', 'Tester4', 'chloe@yahoo.com', 'password2');"
 sqlite3_prepare_v2(db, insertStatement2, -1, &statement2, nil)
 if sqlite3_step(statement2) == SQLITE_DONE{
     print("inserted into authors")
 }else{
     print("not inserted into authors")
 }
 sqlite3_finalize(statement2)
 
 
 var statement3: OpaquePointer?
 let insertStatement3 = "INSERT into foods (name,calories, protein, carbs, fats, authorid) values ('Banana', 110, 1, 10, 2, 39);"
 sqlite3_prepare_v2(db, insertStatement3, -1, &statement3, nil)
 if sqlite3_step(statement3) == SQLITE_DONE{
     print("inserted into foods")
 }else{
     print("not inserted into foods")
 }
 sqlite3_finalize(statement3)
 
 
 var statement4: OpaquePointer?
 let insertStatement4 = "INSERT into workout_category (categoryid) values (26);"
 sqlite3_prepare_v2(db, insertStatement4, -1, &statement4, nil)
 if sqlite3_step(statement4) == SQLITE_DONE{
     print("inserted into workout category")
 }else{
     print("not inserted into workout category")
 }
 sqlite3_finalize(statement4)
 
 
 var statement5: OpaquePointer?
 let insertStatement5 = "INSERT into category (name) values ('Yoga');"
 sqlite3_prepare_v2(db, insertStatement5, -1, &statement5, nil)
 if sqlite3_step(statement5) == SQLITE_DONE{
     print("inserted into category")
 }else{
     print("not inserted into category")
 }
 sqlite3_finalize(statement5)

 
 
 

  DELETE STATEMENTS
  
 let deleteStatement1 = "DELETE from workouts where id >= 0;"
 var ds1: OpaquePointer?
 sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
 if sqlite3_step(ds1) == SQLITE_DONE{
     print("inserted")
 }else{
     print("not inserted")
 }
 sqlite3_finalize(ds1)
 
 
 let deleteStatement2 = "DELETE from author10 where id >= 0;"
 var ds2: OpaquePointer?
 sqlite3_prepare_v2(db, deleteStatement2, -1, &ds2, nil)
 if sqlite3_step(ds2) == SQLITE_DONE{
     print("inserted")
 }else{
     print("not inserted")
 }
 sqlite3_finalize(ds2)
 
 let deleteStatement3 = "DELETE from foods where id >= 0;"
 var ds3: OpaquePointer?
 sqlite3_prepare_v2(db, deleteStatement3, -1, &ds3, nil)
 if sqlite3_step(ds3) == SQLITE_DONE{
     print("inserted")
 }else{
     print("not inserted")
 }
 sqlite3_finalize(ds3)
 
 
 let deleteStatement4 = "DELETE from workout_category where id >= 0;"
 var ds4: OpaquePointer?
 sqlite3_prepare_v2(db, deleteStatement4, -1, &ds4, nil)
 if sqlite3_step(ds4) == SQLITE_DONE{
     print("inserted")
 }else{
     print("not inserted")
 }
 sqlite3_finalize(ds4)
 
 
 let deleteStatement5 = "DELETE from category where id >= 0;"
 var ds5: OpaquePointer?
 sqlite3_prepare_v2(db, deleteStatement5, -1, &ds5, nil)
 if sqlite3_step(ds5) == SQLITE_DONE{
     print("inserted")
 }else{
     print("not inserted")
 }
 sqlite3_finalize(ds5)
*/
