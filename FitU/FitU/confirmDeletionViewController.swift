import UIKit
import Foundation
import SQLite3

public class tempClass2 {
    var ID2 = [Int32]()
    var holder2 = [Int]()
    
}
var tempObj2 = tempClass2()

class confirmDeletionViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    
    @IBOutlet weak var confirmFoodDeletionVCLogo: UIImageView!
    
    
    func inputTaggerintoClass2(t: tempClass2){
        t.ID2.removeAll()
        t.holder2.removeAll()
        
        let queryStatementString = "Select * from temp"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
          // 2
            print("\nQuery Result for Temp table:")
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
        
        let createfoodTable = "CREATE TABLE IF NOT EXISTS userfoodTable (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,calories INTEGER, protein INTEGER, carbs INTEGER, fats INTEGER);"
        if sqlite3_exec(db, createfoodTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening user foods table")
         return
        }
        
        let createTempTable = "CREATE TABLE IF NOT EXISTS temp (id INTEGER PRIMARY KEY AUTOINCREMENT, holder INTEGER);"
        if sqlite3_exec(db, createTempTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp table")
         return
        }
        
        let tempfood = "CREATE TABLE IF NOT EXISTS tempFood (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,calories INTEGER, protein INTEGER, carbs INTEGER, fats INTEGER);"
        if sqlite3_exec(db, tempfood, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp Food table")
         return
        }
        
    }
    
    
    @IBAction func yesButton(_ sender: Any) {
        inputTaggerintoClass2(t: tempObj2)
        var stringID = String(tempObj2.holder2[0])
        print("Trying to delete id: \(stringID)")

        let deleteStatement1 = "DELETE from userfoodTable where id = '\(stringID as! NSString)';"
        var ds1: OpaquePointer?
        sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
        if sqlite3_step(ds1) == SQLITE_DONE{
            print("deleted \(stringID) properly")
        }else{
            print("not deleted \(stringID) properly")
        }
        sqlite3_finalize(ds1)

        guard let userfoodvc = storyboard?.instantiateViewController(identifier: "userFood_vc") as? userFoodsViewController else{
            print("couldnt find page")
            return
            }
        userfoodvc.modalPresentationStyle = .fullScreen
        present(userfoodvc, animated: true)
    }
    
    
    @IBAction func noButton(_ sender: Any) {
        guard let userfoodvc = storyboard?.instantiateViewController(identifier: "userFood_vc") as? userFoodsViewController else{
            print("couldnt find page")
            return
            }
        userfoodvc.modalPresentationStyle = .fullScreen
        present(userfoodvc, animated: true)
    }
 
    @objc func confirmFoodDeletionVCLogoClick(gesture: UIGestureRecognizer){
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(confirmDeletionViewController.confirmFoodDeletionVCLogoClick(gesture:)))
        confirmFoodDeletionVCLogo.addGestureRecognizer(tapGesture)
        confirmFoodDeletionVCLogo.isUserInteractionEnabled = true
    }
    

   

}

