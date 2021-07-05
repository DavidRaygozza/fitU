import UIKit
import Foundation
import SQLite3


public class PersonForHome {
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
}

var peopleForHome = PersonForHome()

public class fitnessData2Class {
    var ID2 = [Int32]()
    var bmr2 = [Int32]()
    var water2 = [Int32]()
    var yourBmr2 = [Int32]()
    var yourWater2 = [Int32]()
}

var fitnessData2Obj = fitnessData2Class()

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var homeVCLogo: UIImageView!
    @IBOutlet weak var calorieProgress: UIProgressView!
    @IBOutlet weak var waterProgress: UIProgressView!
    @IBOutlet weak var dailyCalorieLabel: UILabel!
    @IBOutlet weak var dailyWaterLabel: UILabel!
    
    @IBOutlet weak var waterResetO: UIButton!
    @IBOutlet weak var calResetO: UIButton!
    @IBAction func calReset(_ sender: Any) {
        var statement: OpaquePointer?
        let insertStatement4 = "UPDATE fitnessData2 SET yourBmr = '0';"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
        if sqlite3_step(statement) == SQLITE_DONE{
            print("updated into fitnessData2")
        }else{
            print("not updated into fitnessData2 ")
        }
        sqlite3_finalize(statement)
        getProgresses()
    }
    
    @IBAction func suggestedExercisesButton(_ sender: Any) {
        guard let exercisevc = storyboard?.instantiateViewController(identifier: "exercise_vc") as? ExerciseViewController else{
            print("couldnt find page")
            return
            }
        exercisevc.modalPresentationStyle = .fullScreen
        present(exercisevc, animated: true)
    }
    
    
    
    @IBAction func waterReset(_ sender: Any) {
        var statement: OpaquePointer?
        let insertStatement4 = "UPDATE fitnessData2 SET yourWater = '0';"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
        if sqlite3_step(statement) == SQLITE_DONE{
            print("updated into fitnessData2")
        }else{
            print("not updated into fitnessData2 ")
        }
        sqlite3_finalize(statement)
        getProgresses()
    }
    
    
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        let createfitnessData2table = "CREATE TABLE IF NOT EXISTS fitnessData2 (id INTEGER PRIMARY KEY AUTOINCREMENT, bmr INTEGER, water INTEGER, yourBmr INTEGER, yourWater INTEGER);"
           if sqlite3_exec(db, createfitnessData2table, nil, nil, nil) != SQLITE_OK{
               print ("Error opening fitnessData2 table")
           }
    } // end of maindb info func
    
    func inputfitnessData2(fd: fitnessData2Class){
        fd.ID2.removeAll()
        fd.bmr2.removeAll()
        fd.water2.removeAll()
        fd.yourBmr2.removeAll()
        fd.yourWater2.removeAll()

        let queryStatementString = "Select * from fitnessData2"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
//            print("\nQuery Result for fitnessData2:")
//            print("\nId | BMR | Water | yourBmr | yourWater")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = sqlite3_column_int(queryStatement, 0)
            var bmr = sqlite3_column_int(queryStatement, 1)
            var water = sqlite3_column_int(queryStatement, 2)
            var yourBmr = sqlite3_column_int(queryStatement, 3)
            var yourWater = sqlite3_column_int(queryStatement, 4)
            fd.ID2.append(id)
            fd.bmr2.append(bmr)
            fd.water2.append(water)
            fd.yourBmr2.append(yourBmr)
            fd.yourWater2.append(yourWater)
//            print("\(id) | \(bmr) | \(water) | \(yourBmr) | \(yourWater)")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    }
//     end of inout fitness data func
    
    func getProgresses(){
        inputfitnessData2(fd: fitnessData2Obj)
        dailyCalorieLabel.text = "Daily Calories: \(String(fitnessData2Obj.yourBmr2[0])) of \(String(fitnessData2Obj.bmr2[0]))"
        dailyWaterLabel.text = "Daily Water: \(String(fitnessData2Obj.yourWater2[0])) of \(String(fitnessData2Obj.water2[0])) Oz."
        var top1 = Double(fitnessData2Obj.yourBmr2[0])
        var bottom1 = Double(fitnessData2Obj.bmr2[0])
        var dailyCalorieProgress = Float(top1/bottom1)
        var top2 = Double(fitnessData2Obj.yourWater2[0])
        var bottom2 = Double(fitnessData2Obj.water2[0])
        var dailyWaterProgress = Float(top2/bottom2)

        if(dailyCalorieProgress <= 0.01 || Int(fitnessData2Obj.yourBmr2[0]) == 0){
            calorieProgress.progress = 0.01
        }else{
            calorieProgress.progress = dailyCalorieProgress
        }
        
        if(dailyWaterProgress <= 0.01 || Int(fitnessData2Obj.yourWater2[0]) == 0){
            waterProgress.progress = 0.01
        }else{
            waterProgress.progress = dailyWaterProgress
        }
    }
    
    
    var db: OpaquePointer? // end of input func
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        getProgresses()
//        calResetO.titleEdgeInsets.top = -50
//        calResetO.titleEdgeInsets.bottom = -50
//        calResetO.titleEdgeInsets.left = -50
//        calResetO.titleEdgeInsets.right = -50
//        waterResetO.titleEdgeInsets.top = 5
//        waterResetO.titleEdgeInsets.bottom = 5
//        waterResetO.titleEdgeInsets.left = 5
//        waterResetO.titleEdgeInsets.right = 5
        homeVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.homeVCLogoClick(gesture:)))
        homeVCLogo.addGestureRecognizer(tapGesture)
        homeVCLogo.isUserInteractionEnabled = true
    }
    
    //functions
    @objc func homeVCLogoClick(gesture: UIGestureRecognizer){

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
    
}
