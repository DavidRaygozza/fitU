import UIKit
import Foundation
import SQLite3

public class tempClass5 {
    var ID2 = [Int32]()
    var holder2 = [Int]()
}

public class tempUserExercises {
    var ID2 = [Int32]()
    var name2 = [String]()
    var sets = [Int32]()
    var reps = [Int32]()
    var type2 = [String]()
}

var tempObj5 = tempClass5()
var tempUserExercise = tempUserExercises()

class updateExerciseViewController: UIViewController, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
    
    var type  = ["Upper", "Lower", "Abs", "Yoga", "Cardio"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }

    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    //outlets
    
    @IBOutlet weak var backButton: UIStackView!
    @IBOutlet weak var updateExerciseVCLogo: UIImageView!
    @IBOutlet weak var exerciseNameField: UITextField!
    @IBOutlet weak var exerciseSetsField: UILabel!
    @IBOutlet weak var exerciseRepsField: UILabel!
    
    @IBOutlet weak var exerciseSetsStepperO: UIStepper!
    @IBOutlet weak var exerciseRepsStepperO: UIStepper!
    
    @IBAction func exerciseSetsStepperChange(_ sender: Any) {
        exerciseSetsField.text = "\(exerciseSetsStepperO.value)"
    }
    
    @IBAction func exerciseRepsStepperChange(_ sender: Any) {
        exerciseRepsField.text = "\(exerciseRepsStepperO.value)"
    }
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    
    
    var db: OpaquePointer?
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        let createTempTable = "CREATE TABLE IF NOT EXISTS temp (id INTEGER PRIMARY KEY AUTOINCREMENT, holder INTEGER);"
        if sqlite3_exec(db, createTempTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp table")
         return
        }
        
        let tempexercise = "CREATE TABLE IF NOT EXISTS tempExercise (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sets INTEGER, reps INTEGER, type TEXT);"
        if sqlite3_exec(db, tempexercise, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp Food table")
         return
        }
        
        
    } // end of main db func
    
    
    func inputTaggerintoClass5(t: tempClass5){
        t.ID2.removeAll()
        t.holder2.removeAll()
        
        let queryStatementString = "Select * from tempex"
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
    
    func inputTempExercises2(ue: tempUserExercises){
        ue.ID2.removeAll()
        ue.name2.removeAll()
        ue.sets.removeAll()
        ue.reps.removeAll()
        ue.type2.removeAll()
        
        let queryStatementString = "Select * from userExerciseTable2 order by name asc"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
//            print("\nQuery Result for User Exercises:")
//            print("\nId | Name  | Sets | Reps | Type")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = sqlite3_column_int(queryStatement, 0)
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
              print("Query result for col 1 is nil")
              return
            }
            let name = String(cString: queryResultCol1)
            let sets = sqlite3_column_int(queryStatement, 2)
            let reps = sqlite3_column_int(queryStatement, 3)
            guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
              print("Query result for col 4 is nil")
              return
            }
            let type = String(cString: queryResultCol4)

            ue.ID2.append(id)
            ue.name2.append(name)
            ue.sets.append(sets)
            ue.reps.append(reps)
            ue.type2.append(type)

//            print("\(id) | \(name) | \(sets)| \(reps)| \(type) ")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    } // end of inout temp exercises func
    
    
    
    @IBAction func exerciseUpdateButton(_ sender: Any) {
        var name = exerciseNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var sets = exerciseSetsStepperO.value
        var reps = exerciseRepsStepperO.value
        var type2 = typePicker.selectedRow(inComponent: 0).description

        if(name?.isEmpty)!{
            print("Exercise Name is empty")
            return
        }


        if(((name?.isEmpty) != nil)) {
            var stringID = String(tempObj5.holder2[0])
            print("Trying to update id: \(stringID)")
            
            let deleteStatement1 = "DELETE from userExerciseTable2 where id = '\(stringID as! NSString)';"
            var ds1: OpaquePointer?
            sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
            if sqlite3_step(ds1) == SQLITE_DONE{
                print("deleted \(stringID) properly")
            }else{
                print("not deleted \(stringID) properly")
            }
            sqlite3_finalize(ds1)
            
            var statement5: OpaquePointer?
            let insertStatement4 = "INSERT into userExerciseTable2 (name, sets, reps, type) values ('\(name as! NSString)', '\(sets)', '\(reps)', '\(type2 as! NSString)');"
            sqlite3_prepare_v2(db, insertStatement4, -1, &statement5, nil)
            if sqlite3_step(statement5) == SQLITE_DONE{
                print("inserted into user exercises table")
            }else{
                print("not inserted into user exercises table")
            }
            sqlite3_finalize(statement5)
           
            exerciseNameField.text = ""
            exerciseSetsStepperO.value = 0
            exerciseRepsStepperO.value = 0
            typePicker.selectRow(0, inComponent: 0, animated: false)

            guard let userexercisevc = storyboard?.instantiateViewController(identifier: "userExercise_vc") as? userExerciseViewController else{
                print("couldnt find page")
                return
                }
            userexercisevc.modalPresentationStyle = .fullScreen
            present(userexercisevc, animated: true)

        }else{
            print("There was an error updating the exercise")
        }
    }
    
    @objc func updateExerciseVCLogoClick(gesture: UIGestureRecognizer){
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
    
    @objc func backButtonClick2(gesture: UIGestureRecognizer){

                if (gesture.view as? UIImageView) != nil {
                            print("Image Tapped")
                            //Here you can initiate your new ViewController
                    }
            guard let userexercisevc = storyboard?.instantiateViewController(identifier: "userExercise_vc") as? userExerciseViewController else{
                print("couldnt find page")
                return
                }
            userexercisevc.modalPresentationStyle = .fullScreen
            present(userexercisevc, animated: true)
            } // end of func for logo

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(updateExerciseViewController.backButtonClick2(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         updateExerciseVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateExerciseViewController.updateExerciseVCLogoClick(gesture:)))
        updateExerciseVCLogo.addGestureRecognizer(tapGesture)
        updateExerciseVCLogo.isUserInteractionEnabled = true
        exerciseNameField.delegate = self
        typePicker.delegate = self
        typePicker.dataSource = self
        
        inputTaggerintoClass5(t: tempObj5)
        inputTempExercises2(ue: tempUserExercise)
        var k = 0
        while(k < tempUserExercise.ID2.count){
            if(tempUserExercise.ID2[k] == tempObj5.holder2[0]){
                exerciseNameField.text = "\(tempUserExercise.name2[k])"
                exerciseSetsStepperO.value = Double(tempUserExercise.sets[k])
                exerciseSetsField.text = String(Double(tempUserExercise.sets[k]))
                exerciseRepsStepperO.value = Double(tempUserExercise.reps[k])
                exerciseRepsField.text = String(Double(tempUserExercise.reps[k]))
                var t = Int(tempUserExercise.type2[k])
                typePicker.selectRow(t ?? 0, inComponent: 0, animated: false)

                return
            }else{
                k = k+1
            } // end of if else
        } // end of while
    } // end of view did load
} // end of super main class
