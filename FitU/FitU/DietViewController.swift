import UIKit
import SQLite3
import Foundation


class DietViewController: UIViewController, UITextFieldDelegate {
    
    func deleteinsertcalories(param: Int){
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
    }
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    //outlets that need borders
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    @IBOutlet weak var stackView6: UIStackView!
    @IBOutlet weak var stackView7: UIStackView!
    @IBOutlet weak var stackView8: UIStackView!
    @IBOutlet weak var stack1Cal: UILabel!
    @IBOutlet weak var stack2Cal: UILabel!
    @IBOutlet weak var stack3Cal: UILabel!
    @IBOutlet weak var stack4Cal: UILabel!
    @IBOutlet weak var stack5Cal: UILabel!
    @IBOutlet weak var stack6Cal: UILabel!
    @IBOutlet weak var stack7Cal: UILabel!
    @IBOutlet weak var stack8Cal: UILabel!
    
    @IBOutlet weak var personalListButtonO: UIButton!
    
    @IBOutlet weak var dietVCLogo: UIImageView!
   
    @IBOutlet weak var backButton: UIStackView!
    @IBAction func viewPersonalFoodListCLick(_ sender: Any) {
        guard let userfoodvc = storyboard?.instantiateViewController(identifier: "userFood_vc") as? userFoodsViewController else{
            print("couldnt find page")
            return
            }
        userfoodvc.modalPresentationStyle = .fullScreen
        present(userfoodvc, animated: true)
    }
    
    //try replace occurences to remove string charcaters "Calories: " and Int the rest
    
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
        
        let createCalorieAdditionTable = "CREATE TABLE IF NOT EXISTS calorieAddition (id INTEGER PRIMARY KEY AUTOINCREMENT, cals INTEGER);"
        if sqlite3_exec(db, createCalorieAdditionTable, nil, nil, nil) != SQLITE_OK{
            print ("Error opening temp table")
         return
        }
    } // end of main db info
    
    @objc func backButtonClick(gesture: UIGestureRecognizer){

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

    
    override func viewDidLoad() {
        super.viewDidLoad()
            mainDBInfo()
            borders()
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.backButtonClick(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         dietVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            makeClickableItems()
        personalListButtonO.layer.borderWidth = 15
        personalListButtonO.layer.borderColor = UIColor.white.cgColor
    } //end of veiw did load
    

    
    func borders(){
        stackView1.layer.borderWidth = 1
        stackView1.layer.borderColor = UIColor.systemOrange.cgColor
        stackView2.layer.borderWidth = 1
        stackView2.layer.borderColor = UIColor.systemOrange.cgColor
        stackView3.layer.borderWidth = 1
        stackView3.layer.borderColor = UIColor.systemOrange.cgColor
        stackView4.layer.borderWidth = 1
        stackView4.layer.borderColor = UIColor.systemOrange.cgColor
        stackView5.layer.borderWidth = 1
        stackView5.layer.borderColor = UIColor.systemOrange.cgColor
        stackView6.layer.borderWidth = 1
        stackView6.layer.borderColor = UIColor.systemOrange.cgColor
        stackView7.layer.borderWidth = 1
        stackView7.layer.borderColor = UIColor.systemOrange.cgColor
        stackView8.layer.borderWidth = 1
        stackView8.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
    func openConfirmPage(){
        guard let confirmfoodadditionvc = storyboard?.instantiateViewController(identifier: "confirmFoodAddition_vc") as? confirmFoodAdditionViewController else{
            print("couldnt find page")
            return
            }
        confirmfoodadditionvc.modalPresentationStyle = .fullScreen
        present(confirmfoodadditionvc, animated: true)
    }
    
    //repetitive functions
    func makeClickableItems(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DietViewController.dietVCLogoClick(gesture:)))
        dietVCLogo.addGestureRecognizer(tapGesture)
        dietVCLogo.isUserInteractionEnabled = true
        
        let stackGesture1 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack1Click(gesture:)))
        stackView1.addGestureRecognizer(stackGesture1)
        stackView1.isUserInteractionEnabled = true
        
        let stackGesture2 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack2Click(gesture:)))
        stackView2.addGestureRecognizer(stackGesture2)
        stackView2.isUserInteractionEnabled = true
        
        let stackGesture3 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack3Click(gesture:)))
        stackView3.addGestureRecognizer(stackGesture3)
        stackView3.isUserInteractionEnabled = true
        
        let stackGesture4 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack4Click(gesture:)))
        stackView4.addGestureRecognizer(stackGesture4)
        stackView4.isUserInteractionEnabled = true
        
        let stackGesture5 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack5Click(gesture:)))
        stackView5.addGestureRecognizer(stackGesture5)
        stackView5.isUserInteractionEnabled = true
        
        let stackGesture6 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack6Click(gesture:)))
        stackView6.addGestureRecognizer(stackGesture6)
        stackView6.isUserInteractionEnabled = true
        
        let stackGesture7 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack7Click(gesture:)))
        stackView7.addGestureRecognizer(stackGesture7)
        stackView7.isUserInteractionEnabled = true
        
        let stackGesture8 = UITapGestureRecognizer(target: self, action: #selector(DietViewController.stack8Click(gesture:)))
        stackView8.addGestureRecognizer(stackGesture8)
        stackView8.isUserInteractionEnabled = true
    }
        
    
    
    @objc func dietVCLogoClick(gesture: UIGestureRecognizer){
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
    
    @objc func stack1Click(gesture: UIGestureRecognizer){
        var y = Int(stack1Cal.text!)
        print("Cal: \(stack1Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack2Click(gesture: UIGestureRecognizer){
        var y = Int(stack2Cal.text!)
        print("Cal: \(stack2Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack3Click(gesture: UIGestureRecognizer){
        var y = Int(stack3Cal.text!)
        print("Cal: \(stack3Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack4Click(gesture: UIGestureRecognizer){
        var y = Int(stack4Cal.text!)
        print("Cal: \(stack4Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack5Click(gesture: UIGestureRecognizer){
        var y = Int(stack5Cal.text!)
        print("Cal: \(stack5Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack6Click(gesture: UIGestureRecognizer){
        var y = Int(stack6Cal.text!)
        print("Cal: \(stack6Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack7Click(gesture: UIGestureRecognizer){
        var y = Int(stack7Cal.text!)
        print("Cal: \(stack7Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func
    
    @objc func stack8Click(gesture: UIGestureRecognizer){
        var y = Int(stack8Cal.text!)
        print("Cal: \(stack8Cal.text)")
        deleteinsertcalories(param: y ?? 0)
        openConfirmPage()
    } // end of func

} //end of super mian class



//create temp food addition table
