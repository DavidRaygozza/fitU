import UIKit
import Foundation
import SQLite3

public class tempClass4 {
    var ID2 = [Int32]()
    var holder2 = [Int]()
    
}
var tempObj4 = tempClass4()

class confirmExerciseDeletionViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var confirmExerciseDeletionVCLogo: UIImageView!
    
    
    func inputTaggerintoClass4(t: tempClass4){
        t.ID2.removeAll()
        t.holder2.removeAll()
        
        let queryStatementString = "Select * from tempex"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
          // 2
            print("\nQuery Result for Tempxe table:")
            print("\nId | Tagger")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            // 3
            let id = sqlite3_column_int(queryStatement, 0)
            // 4
            let holder = sqlite3_column_int(queryStatement, 1)
    
            t.ID2.append(id)
            t.holder2.append(Int(holder))
            
            print("\(id) | \(Int(holder))")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    } // end of inout tagger func
    
    var db: OpaquePointer?
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        let createTempexTable = "CREATE TABLE IF NOT EXISTS tempex (id INTEGER PRIMARY KEY AUTOINCREMENT, holder INTEGER);"
        if sqlite3_exec(db, createTempexTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening tempex table")
         return
        }
        
        let tempfood = "CREATE TABLE IF NOT EXISTS tempFood (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,calories INTEGER, protein INTEGER, carbs INTEGER, fats INTEGER);"
        if sqlite3_exec(db, tempfood, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp Food table")
         return
        }
        
    } //end of main db info func
    
    func displayUserExercisePage(){
        guard let userexercisevc = storyboard?.instantiateViewController(identifier: "userExercise_vc") as? userExerciseViewController else{
            print("couldnt find page")
            return
            }
        userexercisevc.modalPresentationStyle = .fullScreen
        present(userexercisevc, animated: true)
    }
    
    @IBAction func yesExerciseButton(_ sender: Any) {
        inputTaggerintoClass4(t: tempObj4)
        var stringID = String(tempObj4.holder2[0])
        print("Trying to delete id: \(stringID)")

        let deleteStatement1 = "DELETE from userExerciseTable2 where id = '\(stringID as! NSString)';"
        var ds1: OpaquePointer?
        sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
        if sqlite3_step(ds1) == SQLITE_DONE{
            print("deleted \(stringID) properly")
        }else{
            print("not deleted \(stringID) properly")
        }
        sqlite3_finalize(ds1)

       displayUserExercisePage()
    }
    
    @IBAction func noExerciseButton(_ sender: Any) {
        displayUserExercisePage()
    }
    
    @objc func confirmExerciseDeletionVCLogoClick(gesture: UIGestureRecognizer){
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmExerciseDeletionViewController.confirmExerciseDeletionVCLogoClick(gesture:)))
        confirmExerciseDeletionVCLogo.addGestureRecognizer(tapGesture)
        confirmExerciseDeletionVCLogo.isUserInteractionEnabled = true
    }
    

  
}
