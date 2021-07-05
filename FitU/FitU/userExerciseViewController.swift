import UIKit
import SQLite3
import Foundation

public class userExercise {
    var ID2 = [Int32]()
    var name2 = [String]()
    var sets = [Int32]()
    var reps = [Int32]()
    var type2 = [String]()
}

var userExerciseObj = userExercise()
let createExerciseObj = CreateWorkoutViewController()
var tagger:Int = 0;


class userExerciseViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    @IBOutlet weak var userExerciseVCLogo: UIImageView!

    
    var db: OpaquePointer?
    func mainDBInfo(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("workoutsDatabse.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print ("Error opening databse")
            return
        }
        
        let createuserExerciseTable2 = "CREATE TABLE IF NOT EXISTS userExerciseTable2 (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sets INTEGER, reps INTEGER, type TEXT);"
        if sqlite3_exec(db, createuserExerciseTable2, nil, nil, nil) != SQLITE_OK{
            print ("Error opening user exercise table")
         return
        }
        
       
        let createTempexTable = "CREATE TABLE IF NOT EXISTS tempex (id INTEGER PRIMARY KEY AUTOINCREMENT, holder INTEGER);"
        if sqlite3_exec(db, createTempexTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp table")
         return
        }
        
        
        let tempexercise = "CREATE TABLE IF NOT EXISTS tempExercise (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, sets INTEGER, reps INTEGER, type TEXT);"
        if sqlite3_exec(db, tempexercise, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp Food table")
         return
        }
 
    } //end of main db info
    
    
    func inputUserExercises(ue: userExercise){
        ue.ID2.removeAll()
        ue.name2.removeAll()
        ue.sets.removeAll()
        ue.reps.removeAll()
        ue.type2.removeAll()
        
        let queryStatementString = "Select * from userExerciseTable2 order by name asc"
        var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            print("\nQuery Result for User Exercises:")
            print("\nId | Name  | Sets | Reps | Type")
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

            print("\(id) | \(name) | \(sets)| \(reps)| \(type) ")
            }
        } else {
          let errorMessage = String(cString: sqlite3_errmsg(db))
          print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        print("\n\n")
    } // end of inout exercises func

    func countExerciseRecords(ue:userExercise) -> Int{
        var k = 0
        while(k < ue.name2.count){
            k = k+1
        }
        return k
    } //end of count records func
    
    @IBAction func createExerciseButton(sender: UIButton){
        print("create button clicked")
        guard let createexercisevc = storyboard?.instantiateViewController(identifier: "createWorkout_vc") as? CreateWorkoutViewController else{
            print("couldnt find page")
            return
            }
        createexercisevc.modalPresentationStyle = .fullScreen
        present(createexercisevc, animated: true)
    } //end of create button clicked func
    
    
    func createExerciseRecords(ue: userExercise){
        var yPos =  CGFloat(100)
        let xPos = CGFloat(self.view.frame.width)
        var g = 0
        
        createButton.setTitle("Add to your list", for: .normal)
        createButton.backgroundColor = .systemOrange
        createButton.addTarget(self,action: #selector(createExerciseButton),for: .touchUpInside)
        createButton.frame = CGRect( x:(xPos/4), y:20, width:(xPos/2), height: 40)
        dynamicExerciseSubStack.isUserInteractionEnabled = true
        dynamicExerciseSubStack.addSubview(createButton)
        
            while(g < ue.ID2.count){
                let nameLabel = UILabel()
                nameLabel.text = "Name: " + ue.name2[g]
                nameLabel.textAlignment = .center
                nameLabel.backgroundColor = .white
                nameLabel.textColor = .darkGray
                nameLabel.layer.borderWidth = 1
                nameLabel.layer.borderColor = UIColor.systemOrange.cgColor
                nameLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 20
                
                let setsLabel = UILabel()
                setsLabel.text = "Sets: \(ue.sets[g])"
                setsLabel.textAlignment = .center
                setsLabel.backgroundColor = .white
                setsLabel.textColor = .darkGray
                setsLabel.layer.borderWidth = 1
                setsLabel.layer.borderColor = UIColor.systemOrange.cgColor
                setsLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 20
                
                let repsLabel = UILabel()
                repsLabel.text = "Reps: \(ue.reps[g])"
                repsLabel.textAlignment = .center
                repsLabel.backgroundColor = .white
                repsLabel.textColor = .darkGray
                repsLabel.layer.borderWidth = 1
                repsLabel.layer.borderColor = UIColor.systemOrange.cgColor
                repsLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 20
                
                var typeText:String = ""
                
                if(ue.type2[g] == "0"){
                    typeText = "Upper"
                }else if(ue.type2[g] == "1"){
                    typeText = "Lower"
                }else if(ue.type2[g] == "2"){
                    typeText = "Abs"
                }else if(ue.type2[g] == "3"){
                    typeText = "Yoga"
                }else if(ue.type2[g] == "4"){
                    typeText = "Cardio"
                }
                
                let typeLabel = UILabel()
                typeLabel.text = "Type: \(typeText)"
                typeLabel.textAlignment = .center
                typeLabel.backgroundColor = .white
                typeLabel.textColor = .darkGray
                typeLabel.layer.borderWidth = 1
                typeLabel.layer.borderColor = UIColor.systemOrange.cgColor
                typeLabel.frame = CGRect( x:-xPos/4, y:yPos, width:(xPos/2), height: 20)
                yPos += 120
               
                stack2.addSubview(nameLabel)
                stack2.insertSubview(setsLabel, belowSubview: nameLabel)
                stack2.insertSubview(repsLabel, belowSubview: setsLabel)
                stack2.insertSubview(typeLabel, belowSubview: repsLabel)
                dynamicExerciseSubStack.addArrangedSubview(stack2)
                g = g + 1
        } // end while
        
        //creates dynamic buttons
        yPos = CGFloat(180)
        var t = -1
        if(userExerciseObj.ID2.count != 0){
            //error here
            for index in (userExerciseObj.ID2){
                t+=1
                var oneBtn2: UIButton = {
                    let myButton = UIButton()
                    myButton.addTarget(self,action: #selector(deleteAction),for: .touchUpInside)
                    myButton.setTitle("Delete \(userExerciseObj.name2[t])", for: .normal)
                    myButton.setTitleColor(.red, for: .highlighted)
                    myButton.frame = CGRect( x:(xPos/4), y:yPos, width:(xPos/2), height: 40)
                    myButton.backgroundColor = .systemOrange
                    myButton.layer.borderWidth = 5
                    myButton.layer.borderColor = UIColor.white.cgColor
                    myButton.tag = Int(userExerciseObj.ID2[t])
                    yPos += 180
                    myButton.isUserInteractionEnabled = true
                    return myButton
                }()
                dynamicExerciseSubStack.isUserInteractionEnabled = true
                dynamicExerciseSubStack.addSubview(oneBtn2)
            }
        }
        
        yPos = CGFloat(220)
        var r = -1
        if(userExerciseObj.ID2.count != 0){
            for index in (userExerciseObj.ID2){
                r+=1
                var twoBtn: UIButton = {
                    let editter = UIButton()
                    editter.addTarget(self,action: #selector(editAction),for: .touchUpInside)
                    editter.setTitle("Edit \(userExerciseObj.name2[r])", for: .normal)
                    editter.setTitleColor(.red, for: .highlighted)
                    editter.frame = CGRect( x:(xPos/4), y:yPos, width:(xPos/2), height: 40)
                    editter.backgroundColor = .systemOrange
                    editter.layer.borderWidth = 5
                    editter.layer.borderColor = UIColor.white.cgColor
                    editter.tag = Int(userExerciseObj.ID2[r])
                    yPos += 180
                    editter.isUserInteractionEnabled = true
                    return editter
                }()
                dynamicExerciseSubStack.isUserInteractionEnabled = true
                dynamicExerciseSubStack.addSubview(twoBtn)
            }
        }
    } // end of create records func
    
    func deleteExerciseTaggerfromDB(){
        let deleteStatement1 = "Delete from tempex where id >= 0;"
        var ds1: OpaquePointer?
        sqlite3_prepare_v2(db, deleteStatement1, -1, &ds1, nil)
        if sqlite3_step(ds1) == SQLITE_DONE{
            print("delete all")
        }else{
            print("not deleted")
        }
        sqlite3_finalize(ds1)
    } //end of delete tagger func
    
    func insertExerciseTaggerintoDB(){
        var statement4: OpaquePointer?
        let insertStatement4 = "INSERT into tempex (holder) values ('\(tagger)');"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement4, nil)
        if sqlite3_step(statement4) == SQLITE_DONE{
            print("inserted into tempex table")
        }else{
            print("not inserted into tempex table")
        }
    } //end of insert tagger func
    
    
    
    
    @IBAction func editAction(sender: UIButton){
        tagger = sender.tag
        deleteExerciseTaggerfromDB()
        insertExerciseTaggerintoDB()
        
        guard let updateexercisevc = storyboard?.instantiateViewController(identifier: "updateExercise_vc") as? updateExerciseViewController else{
            print("couldnt find page")
            return
        }
        updateexercisevc.modalPresentationStyle = .fullScreen
        present(updateexercisevc, animated: true)
        
        
    } //end of delete action button
    
    @IBAction func deleteAction(sender: UIButton){
        tagger = sender.tag
        deleteExerciseTaggerfromDB()
        insertExerciseTaggerintoDB()
        guard let confirmExerciseDeletionvc = storyboard?.instantiateViewController(identifier: "confirmExerciseDeletion_vc") as? confirmExerciseDeletionViewController else{
            print("couldnt find page")
            return
        }
        confirmExerciseDeletionvc.modalPresentationStyle = .fullScreen
        present(confirmExerciseDeletionvc, animated: true)
    } //end of delete action button
    
    
    
    //global outlets
    @IBOutlet weak var dynamicExerciseScrolleView: UIScrollView!
    @IBOutlet weak var dynamicExerciseSubView: UIView!
    @IBOutlet weak var dynamicExerciseSubStack: UIStackView!
    let stack2 = UIStackView()
    let exerciseStack = UIStackView()
    let noRowsLabel = UILabel()
    var oneBtn2 = UIButton()
    var twoBtn = UIButton()
    var createButton = UIButton()
    var tagger:Int = 0
    
    
    @objc func userExerciseVCLogoClick(gesture: UIGestureRecognizer){
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userExerciseViewController.userExerciseVCLogoClick(gesture:)))
        userExerciseVCLogo.addGestureRecognizer(tapGesture)
        userExerciseVCLogo.isUserInteractionEnabled = true
        
        
        inputUserExercises(ue: userExerciseObj)
                        
        if(countExerciseRecords(ue: userExerciseObj) == 0){
            let xPos = CGFloat(self.view.frame.width)
            createButton.setTitle("Add to your list", for: .normal)
            createButton.backgroundColor = .systemOrange
            createButton.addTarget(self,action: #selector(createExerciseButton),for: .touchUpInside)
            createButton.frame = CGRect( x:(xPos/4), y:20, width:(xPos/2), height: 40)
            
            print("No rows here")
            noRowsLabel.text = "No exercises in your personal list"
            noRowsLabel.textAlignment = .center
            noRowsLabel.frame = CGRect( x:0, y:80, width:(xPos), height: 80)
            dynamicExerciseSubStack.addSubview(createButton)
            dynamicExerciseSubStack.insertSubview(noRowsLabel, belowSubview: createButton)
            dynamicExerciseScrolleView.isScrollEnabled = false

        }else{
            var h = (300 * (countExerciseRecords(ue: userExerciseObj)))
            h  = h - 200
            if(h < 896){
                h = 896
            }
            
            
            dynamicExerciseSubView.heightAnchor.constraint(equalToConstant: CGFloat(h)).isActive = true

            createExerciseRecords(ue: userExerciseObj)
        }
    }
    

    
}
