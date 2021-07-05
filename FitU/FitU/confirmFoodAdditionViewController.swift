import UIKit
import SQLite3
import Foundation

public class fitnessDataConfirmFoodClass {
    var ID2 = [Int32]()
    var bmr2 = [Int32]()
    var water2 = [Int32]()
    var yourBmr2 = [Int32]()
    var yourWater2 = [Int32]()
}
var fitnessDataConfirmFood2Obj = fitnessDataConfirmFoodClass()

public class calWantToAddClass {
    var ID2 = [Int32]()
    var cals2 = [Int]()
    
}
var calWantToAddObj = calWantToAddClass()

class confirmFoodAdditionViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    func inputCals(t: calWantToAddClass){
        t.ID2.removeAll()
        t.cals2.removeAll()
        let queryStatementString = "Select * from calorieAddition"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
          // 2
//            print("\nQuery Result for calorieAddition table:")
//            print("\nId | Cals")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            // 3
            let id = sqlite3_column_int(queryStatement, 0)
            // 4
            let cals = sqlite3_column_int(queryStatement, 1)
            t.ID2.append(id)
            t.cals2.append(Int(cals))
//            print("\(id) | \(Int(cals))")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    } // end of inout tagger func
    
    func inputfitnessDataForConfirmFood(fd: fitnessDataConfirmFoodClass){
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
    
    @IBAction func yesButton(_ sender: Any) {
        var total = Int(fitnessDataConfirmFood2Obj.yourBmr2[0]) + Int(calWantToAddObj.cals2[0])
        
        var statement: OpaquePointer?
        let insertStatement4 = "UPDATE fitnessData2 SET yourBmr = '\(total)';"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
        if sqlite3_step(statement) == SQLITE_DONE{
            print("updated into fitnessData2")
        }else{
            print("not updated into fitnessData2 ")
        }
        sqlite3_finalize(statement)
        
        guard let homevc = storyboard?.instantiateViewController(identifier: "home_vc") as? HomeViewController else{
            print("couldnt find page")
            return
            }
        homevc.modalPresentationStyle = .fullScreen
        present(homevc, animated: true)
    }
    
    @IBAction func noButton(_ sender: Any) {
        guard let dietvc = storyboard?.instantiateViewController(identifier: "diet_vc") as? DietViewController else{
            print("couldnt find page")
            return
            }
        dietvc.modalPresentationStyle = .fullScreen
        present(dietvc, animated: true)
    }
    
    var db: OpaquePointer?
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
        
        let createCalorieAdditionTable = "CREATE TABLE IF NOT EXISTS calorieAddition (id INTEGER PRIMARY KEY AUTOINCREMENT, cals INTEGER);"
        if sqlite3_exec(db, createCalorieAdditionTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp table")
         return
        }
        
    } // end of main db info

    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        inputfitnessDataForConfirmFood(fd: fitnessDataConfirmFood2Obj)
        inputCals(t: calWantToAddObj)
        mainLabel.text = "Add \(Int(calWantToAddObj.cals2[0])) calories to your day?"
    }
}
