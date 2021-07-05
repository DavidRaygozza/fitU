import UIKit
import SQLite3
import Foundation

extension String {
    var isInt4: Bool {
        return Int(self) != nil
    }
}

class CreateFoodViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var calLabel: UILabel!
  
    @IBOutlet weak var backButton: UIStackView!
    @IBOutlet weak var calField: UITextField!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var proteinField: UITextField!
    @IBOutlet weak var carbLabel: UILabel!
    
    @IBOutlet weak var carbField: UITextField!
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var fatField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var createFoodVCLogo: UIImageView!
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
        
    }
    
    
    
   
    
   
    
    
    @IBAction func createFoodButton(_ sender: Any) {
        var name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var calories = calField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var protein = proteinField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var carbs = carbField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var fats2 = fatField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        nameLabel.textColor = .darkGray
        calLabel.textColor = .darkGray
        proteinLabel.textColor = .darkGray
        carbLabel.textColor = .darkGray
        fatLabel.textColor = .darkGray
        
        if(((calories!.isInt4)==true) && ((protein!.isInt4)==true) && ((carbs!.isInt4)==true) && ((fats2!.isInt4)==true) && (name?.isEmpty) == false){
            print("No errors found")
            var statement5: OpaquePointer?
            let insertStatement4 = "INSERT into userfoodTable (name, calories, protein, carbs, fats) values ('\(name as! NSString)', '\(calories as! NSString)', '\(protein as! NSString)', '\(carbs as! NSString)', '\(fats2 as! NSString)');"
            sqlite3_prepare_v2(db, insertStatement4, -1, &statement5, nil)
            if sqlite3_step(statement5) == SQLITE_DONE{
                print("inserted into foods table")
                guard let userfoodvc = storyboard?.instantiateViewController(identifier: "userFood_vc") as? userFoodsViewController else{
                    print("couldnt find page")
                    return
                    }
                userfoodvc.modalPresentationStyle = .fullScreen
                present(userfoodvc, animated: true)
            }else{
                print("not inserted into foods table")
            }
            sqlite3_finalize(statement5)
            nameField.text = ""
            calField.text = ""
            proteinField.text = ""
            carbField.text = ""
            fatField.text = ""
        }else{
            print("erorrs were found")
            if((name?.isEmpty) == true){
                print("Error is in name")
                nameLabel.textColor = .red
            }
            
            if(((calories!.isInt4)==false) || (calories?.isEmpty) == true){
                calLabel.textColor = .red
                print("Error is in cal")
            }
            
            if(((protein!.isInt4)==false) || (protein?.isEmpty) == true){
                proteinLabel.textColor = .red
                print("Error is in protein")

            }
            
            if(((fats2!.isInt4)==false) || (fats2?.isEmpty) == true){
                fatLabel.textColor = .red
                print("Error is in fats")
            }
            
            if(((carbs!.isInt4)==false) || (carbs?.isEmpty) == true){
                carbLabel.textColor = .red
                print("Error is in carbs")
            }
        }
    } // end of crete food func
    
    @objc func createFoodVCLogoClick(gesture: UIGestureRecognizer){
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
            guard let userfoodvc = storyboard?.instantiateViewController(identifier: "userFood_vc") as? userFoodsViewController else{
                print("couldnt find page")
                return
                }
            userfoodvc.modalPresentationStyle = .fullScreen
            present(userfoodvc, animated: true)
            } // end of func for logo

    override func viewDidLoad() {
        super.viewDidLoad()
       mainDBInfo()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(CreateFoodViewController.backButtonClick2(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         createFoodVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        nameField.delegate = self
        calField.delegate = self
        proteinField.delegate = self
        carbField.delegate = self
        fatField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateFoodViewController.createFoodVCLogoClick(gesture:)))
        createFoodVCLogo.addGestureRecognizer(tapGesture)
        createFoodVCLogo.isUserInteractionEnabled = true
    } // end of view did load
} // end of main super class
