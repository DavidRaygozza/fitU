import UIKit
import Foundation
import SQLite3

extension String {
    var isInt3: Bool {
        return Int(self) != nil
    }
}

public class tempClass3 {
    var ID2 = [Int32]()
    var holder2 = [Int]()
}

public class tempUserFoods {
    var ID2 = [Int32]()
    var name2 = [String]()
    var calories2 = [Int32]()
    var proteins2 = [Int32]()
    var carbs2 = [Int32]()
    var fats2 = [Int32]()
}

var tempObj3 = tempClass3()
var tempUserFood = tempUserFoods()

class updateFoodViewController: UIViewController, UITextFieldDelegate{
    
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
    @IBOutlet weak var updateFoodVCLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var calLabel: UILabel!
    
    @IBOutlet weak var calField: UITextField!
    
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var protienField: UITextField!
    
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var carbsField: UITextField!
    
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var fatsField: UITextField!
    
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
        
    } // end of main db func
    
    
    func inputTaggerintoClass2(t: tempClass3){
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
    
    func inputTempUserFoods2(uf: tempUserFoods){
        uf.ID2.removeAll()
        uf.name2.removeAll()
        uf.calories2.removeAll()
        uf.proteins2.removeAll()
        uf.carbs2.removeAll()
        uf.fats2.removeAll()

        
        let queryStatementString = "Select * from userfoodTable"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
          // 2
//            print("\nQuery Result for User Foods:")
//            print("\nId | Name  | Calories | Protein | Carbs | Fats")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            // 3
            let id = sqlite3_column_int(queryStatement, 0)
            // 4
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
              print("Query result for col 1 is nil")
              return
            }
            let name = String(cString: queryResultCol1)
            let calories = sqlite3_column_int(queryStatement, 2)
            let protein = sqlite3_column_int(queryStatement, 3)
            let carbs = sqlite3_column_int(queryStatement, 4)
            let fats = sqlite3_column_int(queryStatement, 5)

            uf.ID2.append(id)
            uf.name2.append(name)
            uf.calories2.append(calories)
            uf.proteins2.append(carbs)
            uf.carbs2.append(carbs)
            uf.fats2.append(fats)

//            print("\(id) | \(name) | \(calories)| \(protein)| \(carbs) | \(fats) ")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    } // end of inout foods func
    
    
    @IBAction func updateButton(_ sender: Any) {
        var name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var calories = calField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var protein = protienField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var carbs = carbsField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        var fats2 = fatsField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        nameLabel.textColor = .darkGray
        calLabel.textColor = .darkGray
        proteinLabel.textColor = .darkGray
        carbsLabel.textColor = .darkGray
        fatsLabel.textColor = .darkGray

        if(((calories!.isInt4)==true) && ((protein!.isInt4)==true) && ((carbs!.isInt4)==true) && ((fats2!.isInt4)==true) && (name?.isEmpty) == false){
            var stringID = String(tempObj3.holder2[0])
            print("Trying to update id: \(stringID)")
            
            let deleteStatement1 = "DELETE from userfoodTable where id = '\(stringID as! NSString)';"
            var ds1: OpaquePointer?
            sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
            if sqlite3_step(ds1) == SQLITE_DONE{
                print("deleted \(stringID) properly")
            }else{
                print("not deleted \(stringID) properly")
            }
            sqlite3_finalize(ds1)
            
            var statement5: OpaquePointer?
            let insertStatement4 = "INSERT into userfoodTable (name, calories, protein, carbs, fats) values ('\(name as! NSString)', '\(calories as! NSString)', '\(protein)', '\(carbs as! NSString)', '\(fats2 as! NSString)');"
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
            protienField.text = ""
            carbsField.text = ""
            fatsField.text = ""
            }else{
            print("There was an error updating the food")
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
                fatsLabel.textColor = .red
                print("Error is in fats")
            }
            
            if(((carbs!.isInt4)==false) || (carbs?.isEmpty) == true){
                carbsLabel.textColor = .red
                print("Error is in carbs")
            }
        }
        
        
        
    } //  end of update statement
    
    @objc func updateFoodVCLogoClick(gesture: UIGestureRecognizer){
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
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(updateFoodViewController.backButtonClick2(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         updateFoodVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        nameField.delegate = self
        calField.delegate = self
        protienField.delegate = self
        carbsField.delegate = self
        fatsField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateFoodViewController.updateFoodVCLogoClick(gesture:)))
        updateFoodVCLogo.addGestureRecognizer(tapGesture)
        updateFoodVCLogo.isUserInteractionEnabled = true
        
        
        inputTaggerintoClass2(t: tempObj3)
        inputTempUserFoods2(uf: tempUserFood)
        var k = 0
        while(k < userFoodObj.ID2.count){
            if(userFoodObj.ID2[k] == tempObj3.holder2[0]){
                nameField.text = "\(userFoodObj.name2[k])"
                calField.text = "\(userFoodObj.calories2[k])"
                protienField.text = "\(userFoodObj.proteins2[k])"
                carbsField.text = "\(userFoodObj.carbs2[k])"
                fatsField.text = "\(userFoodObj.fats2[k])"
                return
            }else{
                k = k+1
            }
        }
        
        //here i will run the functions to find data from array class with index tagger and then match it to info being displayed
        

        
    } // ewnd of view did load
} // end of main super class
