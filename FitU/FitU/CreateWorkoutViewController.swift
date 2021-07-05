import UIKit
import Foundation
import SQLite3

class CreateWorkoutViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
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

    
    @IBOutlet weak var backButton: UIStackView!
    @IBOutlet weak var createExerciseVCLogo: UIImageView!
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var repsLabel: UILabel!
    @IBOutlet var setsStepperO: UIStepper!
    @IBOutlet var repsStepperO: UIStepper!
    @IBOutlet weak var typePicker: UIPickerView!
    
    @IBAction func setsStepper(_ sender: Any) {
        setsLabel.text = "\(setsStepperO.value)"
    }
    
    @IBAction func repsStepper(_ sender: Any) {
        repsLabel.text = "\(repsStepperO.value)"
    }
    
    @IBAction func createWorkoutButton(_ sender: Any) {
        
        var name = nameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var sets2 = setsStepperO.value
        var reps2 = repsStepperO.value
        var type2 = typePicker.selectedRow(inComponent: 0).description
        print("Type: \(type2)")
        
        if(name?.isEmpty)!{
            print("Workout Name is empty")
            return
        }
        
        var statement4: OpaquePointer?
        let insertStatement4 = "INSERT into userExerciseTable2 (name, sets, reps, type) values ('\(name as! NSString)', '\(sets2)', '\(reps2)', '\(type2  as! NSString)');"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement4, nil)
        if sqlite3_step(statement4) == SQLITE_DONE{
            print("inserted into user exercise table")
        }else{
            print("not inserted into user exercise table")
        }
        
        sqlite3_finalize(statement4)
        
        nameLabel.text = ""
        setsStepperO.value = 0
        repsStepperO.value = 0
        typePicker.selectRow(0, inComponent: 0, animated: false)

        
        if(((name?.isEmpty) != nil)) {
            guard let userexercisevc = storyboard?.instantiateViewController(identifier: "userExercise_vc") as? userExerciseViewController else{
                print("couldnt find page")
                return
                }
            userexercisevc.modalPresentationStyle = .fullScreen
            present(userexercisevc, animated: true)
        }else{
            print("There was an error creating the workout")
        }
        
        let queryStatementString = "Select * from userExerciseTable2"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
          // 2
//            print("\nQuery Result for user workouts:")
//            print("\nId | Name  | Sets | Reps | Type")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            // 3
            let id = sqlite3_column_int(queryStatement, 0)
            // 4
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
              print("Query result for col 1 is nil")
              return
            }
            let name = String(cString: queryResultCol1)
            // 5
            let sets = sqlite3_column_int(queryStatement, 2)
            let reps = sqlite3_column_int(queryStatement, 3)
            let type = sqlite3_column_int(queryStatement, 4)


//            print("\(id) | \(name) | \(sets)| \(reps)| \(type) ")
            }
        } else {
            // 6
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
        
        print("\n\n")
        
    }
    
    @objc func createExerciseVCLogoClick(gesture: UIGestureRecognizer){
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
    
    
    var db: OpaquePointer?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(CreateWorkoutViewController.backButtonClick2(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         createExerciseVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateWorkoutViewController.createExerciseVCLogoClick(gesture:)))
        createExerciseVCLogo.addGestureRecognizer(tapGesture)
        createExerciseVCLogo.isUserInteractionEnabled = true

        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        nameLabel.delegate = self
        typePicker.delegate = self
        typePicker.dataSource = self
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS userExerciseTable2 (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sets INTEGER, reps INTEGER, type TEXT);"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
            print ("Error opening table")
            return
        }
        
        
    } // end of view did load
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
