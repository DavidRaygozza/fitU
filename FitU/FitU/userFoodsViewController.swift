import UIKit
import SQLite3
import Foundation
import SwiftUI

public class userFood {
    var ID2 = [Int32]()
    var name2 = [String]()
    var calories2 = [Int32]()
    var proteins2 = [Int32]()
    var carbs2 = [Int32]()
    var fats2 = [Int32]()
}

public class tempClass {
    var ID2 = [Int32]()
    var holder2 = [Int]()
    
}
var userFoodObj = userFood()
var tempObj = tempClass()

    let createfoodVCObj = CreateFoodViewController()

class userFoodsViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var userFoodVCLogo: UIImageView!
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
        
        let createCalorieAdditionTable = "CREATE TABLE IF NOT EXISTS calorieAddition (id INTEGER PRIMARY KEY AUTOINCREMENT, cals INTEGER);"
        if sqlite3_exec(db, createCalorieAdditionTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp table")
         return
        }
        
    }
    
    func deleteTaggerfromDB(){
        let deleteStatement1 = "Delete from temp where id >= 0;"
        var ds1: OpaquePointer?
        sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
        if sqlite3_step(ds1) == SQLITE_DONE{
            print("delete all")
        }else{
            print("not deleted")
        }
        sqlite3_finalize(ds1)
        
    }

    
    func insertTaggerintoDB(){
        var statement4: OpaquePointer?
        let insertStatement4 = "INSERT into temp (holder) values ('\(tagger)');"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement4, nil)
        if sqlite3_step(statement4) == SQLITE_DONE{
            print("inserted into temp table")
        }else{
            print("not inserted into temp table")
        }
    }
    
    func inputUserFoods(uf: userFood){
        uf.ID2.removeAll()
        uf.name2.removeAll()
        uf.calories2.removeAll()
        uf.proteins2.removeAll()
        uf.carbs2.removeAll()
        uf.fats2.removeAll()

        
        let queryStatementString = "Select * from userfoodTable order by name asc"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            print("\nQuery Result for User Foods:")
            print("\nId | Name  | Calories | Protein | Carbs | Fats")
          while sqlite3_step(queryStatement) == SQLITE_ROW {
            let id = sqlite3_column_int(queryStatement, 0)
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

            print("\(id) | \(name) | \(calories)| \(protein)| \(carbs) | \(fats) ")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    } // end of inout foods func
    
    
    @IBOutlet weak var backButton: UIStackView!
    
    @IBOutlet var subStack: UIStackView!
    
    func countRecords(uf:userFood) -> Int{
        var k = 0
        while(k < uf.name2.count){
            k = k+1
        }
        return k
    }
    
    //global sub view elements
    let stack2 = UIStackView()
    let noRowsLabel = UILabel()
    var oneBtn2 = UIButton()
    var twoBtn = UIButton()
    var threeBtn = UIButton()
    var createButton = UIButton()
    var tagger:Int = 0
    @IBOutlet weak var dynamicHeightView: UIView!
    
    @IBOutlet weak var dynamicScrollView: UIScrollView!
    
    func createRecords(uf: userFood){
        var yPos =  CGFloat(80)
        let xPos = CGFloat(self.view.frame.width)
        var g = 0
        
        createButton.setTitle("Add to your list", for: .normal)
        createButton.backgroundColor = .systemOrange
        createButton.addTarget(self,action: #selector(create),for: .touchUpInside)
        createButton.frame = CGRect( x:(xPos/4), y:20, width:(xPos/2), height: 40)
        subStack.isUserInteractionEnabled = true
        subStack.addSubview(createButton)
        
            while(g < uf.ID2.count){
                let nameLabel = UILabel()
                nameLabel.text = "Name: " + uf.name2[g]
                nameLabel.textAlignment = .center
                nameLabel.backgroundColor = .white
                nameLabel.textColor = .darkGray
                nameLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                nameLabel.layer.borderWidth = 1
                nameLabel.layer.borderColor = UIColor.systemOrange.cgColor
                yPos += 20
                
                let caloriesLabel = UILabel()
                caloriesLabel.text = "Calories: \(uf.calories2[g])"
                caloriesLabel.textAlignment = .center
                caloriesLabel.backgroundColor = .white
                caloriesLabel.textColor = .darkGray
                caloriesLabel.layer.borderWidth = 1
                caloriesLabel.layer.borderColor = UIColor.systemOrange.cgColor
                caloriesLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 20
                
                let proteinLabel = UILabel()
                proteinLabel.text = "Protein: \(uf.proteins2[g])"
                proteinLabel.textAlignment = .center
                proteinLabel.backgroundColor = .white
                proteinLabel.textColor = .darkGray
                proteinLabel.layer.borderWidth = 1
                proteinLabel.layer.borderColor = UIColor.systemOrange.cgColor
                proteinLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 20
                
                let carbsLabel = UILabel()
                carbsLabel.text = "Carbs: \(uf.carbs2[g])"
                carbsLabel.textAlignment = .center
                carbsLabel.backgroundColor = .white
                carbsLabel.textColor = .darkGray
                carbsLabel.layer.borderWidth = 1
                carbsLabel.layer.borderColor = UIColor.systemOrange.cgColor
                carbsLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 20
                
                let fatsLabel = UILabel()
                fatsLabel.text = "Fats: \(uf.fats2[g])"
                fatsLabel.textAlignment = .center
                fatsLabel.backgroundColor = .white
                fatsLabel.textColor = .darkGray
                fatsLabel.layer.borderWidth = 1
                fatsLabel.layer.borderColor = UIColor.systemOrange.cgColor
                fatsLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 180
               
                stack2.addSubview(nameLabel)
                stack2.insertSubview(caloriesLabel, belowSubview: nameLabel)
                stack2.insertSubview(proteinLabel, belowSubview: caloriesLabel)
                stack2.insertSubview(carbsLabel, belowSubview: proteinLabel)
                stack2.insertSubview(fatsLabel, belowSubview: carbsLabel)
                subStack.addArrangedSubview(stack2)
                g = g + 1
        } // end while
        
        //creates dynamic buttons
        yPos = CGFloat(180)
        var t = -1
        if(userFoodObj.ID2.count != 0){
            for index in (userFoodObj.ID2){
                t+=1
                var oneBtn2: UIButton = {
                    let myButton = UIButton()
                    myButton.addTarget(self,action: #selector(deleteAction),for: .touchUpInside)
                    myButton.setTitle("Delete", for: .normal)
                    myButton.setTitleColor(.red, for: .highlighted)
                    myButton.frame = CGRect( x:(xPos/4), y:yPos, width:(xPos/2), height: 40)
                    myButton.tag = Int(userFoodObj.ID2[t])
                    myButton.backgroundColor = .systemOrange
                    myButton.layer.borderWidth = 5
                    myButton.layer.borderColor = UIColor.white.cgColor
                    yPos += 260
                    myButton.isUserInteractionEnabled = true
                    return myButton
                }()
                subStack.isUserInteractionEnabled = true
                subStack.addSubview(oneBtn2)
            }
        }
        
        yPos = CGFloat(220)
        var r = -1
        if(userFoodObj.ID2.count != 0){
            for index in (userFoodObj.ID2){
                r+=1
                var twoBtn: UIButton = {
                    let editter = UIButton()
                    editter.addTarget(self,action: #selector(editAction),for: .touchUpInside)
                    editter.setTitle("Edit", for: .normal)
                    editter.setTitleColor(.red, for: .highlighted)
                    editter.frame = CGRect( x:(xPos/4), y:yPos, width:(xPos/2), height: 40)
                    editter.backgroundColor = .systemOrange
                    editter.tag = Int(userFoodObj.ID2[r])
                    editter.layer.borderWidth = 5
                    editter.layer.borderColor = UIColor.white.cgColor
                    yPos += 260
                    editter.isUserInteractionEnabled = true
                    return editter
                }()
                subStack.isUserInteractionEnabled = true
                subStack.addSubview(twoBtn)
            }
        }
        
        yPos = CGFloat(260)
        var l = -1
        if(userFoodObj.ID2.count != 0){
            for index in (userFoodObj.ID2){
                l+=1
                var threeBtn: UIButton = {
                    let eatter = UIButton()
                    eatter.addTarget(self,action: #selector(eatThisAction),for: .touchUpInside)
                    eatter.setTitle("Eat This!", for: .normal)
                    eatter.setTitleColor(.red, for: .highlighted)
                    eatter.frame = CGRect( x:(xPos/4), y:yPos, width:(xPos/2), height: 40)
                    eatter.backgroundColor = .systemOrange
                    eatter.tag = Int(userFoodObj.calories2[l])
                    eatter.layer.borderWidth = 5
                    eatter.layer.borderColor = UIColor.white.cgColor
                    yPos += 260
                    eatter.isUserInteractionEnabled = true
                    return eatter
                }()
                subStack.isUserInteractionEnabled = true
                subStack.addSubview(threeBtn)
            }
        } //end of dynamic eat buttons
        
    } // end of create records func
    
    
    
    @IBAction func deleteAction(sender: UIButton){
        tagger = sender.tag
        deleteTaggerfromDB()
        insertTaggerintoDB()
        guard let confirmDeletionvc = storyboard?.instantiateViewController(identifier: "confirmDeletion_vc") as? confirmDeletionViewController else{
            print("couldnt find page")
            return
        }
        confirmDeletionvc.modalPresentationStyle = .fullScreen
        present(confirmDeletionvc, animated: true)
    }
    
    @IBAction func editAction(sender: UIButton){
        tagger = sender.tag
        deleteTaggerfromDB()
        insertTaggerintoDB()
        
        var k = 0
        while(k < userFoodObj.ID2.count){
            if(userFoodObj.ID2[k] == tagger){
                
                //delete all temp foods from table
                let deleteStatement1 = "Delete from tempFood where id >= 0;"
                var ds1: OpaquePointer?
                sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
                if sqlite3_step(ds1) == SQLITE_DONE{
                    print("delete all temp foods")
                }else{
                    print("not deleted all temp food")
                }
                sqlite3_finalize(ds1)
                
                //insert into temo food db
                var statement5: OpaquePointer?
                let insertStatement4 = "INSERT into tempFood (name, calories, protein, carbs, fats) values ('\(userFoodObj.name2[k] as! NSString)', '\(userFoodObj.calories2[k])', '\(userFoodObj.proteins2[k])', '\(userFoodObj.carbs2[k])', '\(userFoodObj.fats2[k])');"
                sqlite3_prepare_v2(db, insertStatement4, -1, &statement5, nil)
                if sqlite3_step(statement5) == SQLITE_DONE{
                    print("inserted into temp foods table")
                }else{
                    print("not inserted into temp foods table")
                }
                sqlite3_finalize(statement5)
                
                
                guard let updatefoodvc = storyboard?.instantiateViewController(identifier: "updateFood_vc") as? updateFoodViewController else{
                    print("couldnt find page")
                    return
                }
                updatefoodvc.modalPresentationStyle = .fullScreen
                present(updatefoodvc, animated: true)
                
                return
            }else{
                k = k+1
            }
        }
    }
    
    @IBAction func eatThisAction(sender: UIButton){
        tagger = sender.tag
        print("Cal: \(String(tagger))")
        insertdelete(param: tagger)
        guard let confirmfoodadditionvc = storyboard?.instantiateViewController(identifier: "confirmFoodAddition_vc") as? confirmFoodAdditionViewController else{
            print("couldnt find page")
            return
            }
        confirmfoodadditionvc.modalPresentationStyle = .fullScreen
        present(confirmfoodadditionvc, animated: true)
    }
    
    func insertdelete(param: Int){
        let deleteStatement1 = "Delete from calorieAddition where id >= 0;"
        var ds1: OpaquePointer?
        sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
        if sqlite3_step(ds1) == SQLITE_DONE{
            print("delete all")
        }else{
            print("not deleted")
        }
        sqlite3_finalize(ds1)
        
        var statement4: OpaquePointer?
        let insertStatement4 = "INSERT into calorieAddition (cals) values ('\(param)');"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement4, nil)
        if sqlite3_step(statement4) == SQLITE_DONE{
            print("inserted into calorieAddition table")
        }else{
            print("not inserted into calorieAdditionv table")
        }
    } //end of insert delete func
    
    @IBAction func create(sender: UIButton){
        print("create button clicked")
        guard let createfoodvc = storyboard?.instantiateViewController(identifier: "createFood_vc") as? CreateFoodViewController else{
            print("couldnt find page")
            return
            }
        createfoodvc.modalPresentationStyle = .fullScreen
        present(createfoodvc, animated: true)
    }
    
    @objc func userFoodVCLogoClick(gesture: UIGestureRecognizer){
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
            guard let dietvc = storyboard?.instantiateViewController(identifier: "diet_vc") as? DietViewController else{
            print("couldnt find page")
            return
            }
        dietvc.modalPresentationStyle = .fullScreen
        present(dietvc, animated:true)
        } // end of func for logo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(userFoodsViewController.backButtonClick(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         userFoodVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userFoodsViewController.userFoodVCLogoClick(gesture:)))
        userFoodVCLogo.addGestureRecognizer(tapGesture)
        userFoodVCLogo.isUserInteractionEnabled = true
        inputUserFoods(uf: userFoodObj)
        
                        
        if(countRecords(uf: userFoodObj) == 0){
            let xPos = CGFloat(self.view.frame.width)
            createButton.setTitle("Add", for: .normal)
            createButton.backgroundColor = .systemOrange
            createButton.addTarget(self,action: #selector(create),for: .touchUpInside)
            createButton.frame = CGRect( x:(xPos/4), y:20, width:(xPos/2), height: 40)
            
            print("No rows here")
            noRowsLabel.text = "No foods in your personal list"
            noRowsLabel.textColor = .darkGray
            noRowsLabel.textAlignment = .center
            noRowsLabel.frame = CGRect( x:0, y:80, width:(xPos), height: 80)
            subStack.addSubview(createButton)
            subStack.insertSubview(noRowsLabel, belowSubview: createButton)
            dynamicScrollView.isScrollEnabled = false
        }else{
            var h = (300 * (countRecords(uf: userFoodObj)))
            h  = h - 100
            if(h < 896){
                h = 896
            }
            dynamicHeightView.heightAnchor.constraint(equalToConstant: CGFloat(h)).isActive = true
            createRecords(uf: userFoodObj)
        }
    } // end of view did load
    
} //end of main class
