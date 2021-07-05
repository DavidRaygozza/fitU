import UIKit
import Foundation
import SQLite3

public class fitnessDataWaterClass {
    var ID2 = [Int32]()
    var bmr2 = [Int32]()
    var water2 = [Int32]()
    var yourBmr2 = [Int32]()
    var yourWater2 = [Int32]()
}
var fitnessDataWater2Obj = fitnessDataWaterClass()

class NewViewController: UIViewController, UITextFieldDelegate {
    
    //return key funcs
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }

    //outlets
    @IBOutlet weak var waterVCLogo: UIImageView!
    @IBOutlet var intakeButtonOutlet: UIButton!
    @IBOutlet weak var ouncesStepperO: UIStepper!
    @IBAction func ouncesStepperChange(_ sender: Any) {
        ouncesLabel.text = "\(Int(ouncesStepperO.value)) Oz."
    }
    @IBOutlet weak var ouncesLabel: UILabel!
    @IBOutlet weak var waterImage: UIImageView!
    
    @IBOutlet weak var todaysIntakeLabel: UILabel!
    
    @IBOutlet weak var backButton: UIStackView!
    @IBAction func resetButton(_ sender: Any) {
        var statement: OpaquePointer?
        let insertStatement4 = "UPDATE fitnessData2 SET yourWater = '0';"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
        if sqlite3_step(statement) == SQLITE_DONE{
            print("updated into fitnessData2")
        }else{
            print("not updated into fitnessData2 ")
        }
        sqlite3_finalize(statement)
        getWaterPercentage()
    } //end of reset to 0 button
    
    @IBAction func intakeButton(_ sender: Any) {
        inputfitnessDataForWater(fd: fitnessDataWater2Obj)
        var oz = Int(ouncesStepperO.value)
        oz += Int(fitnessDataWater2Obj.yourWater2[0])
        ouncesStepperO.value = 0
        ouncesLabel.text = "0 Oz."
        var statement: OpaquePointer?
        let insertStatement4 = "UPDATE fitnessData2 SET yourWater = '\(oz)' where yourWater = '\(fitnessDataWater2Obj.yourWater2[0])';"
        sqlite3_prepare_v2(db, insertStatement4, -1, &statement, nil)
        if sqlite3_step(statement) == SQLITE_DONE{
            print("updated into fitnessData2")
        }else{
            print("not updated into fitnessData2 ")
        }
        sqlite3_finalize(statement)
        getWaterPercentage()
    }
    
    func findDate(){
//        let now = Date()
//        let formatter = DateFormatter()
//        formatter.dateStyle = .none
//        formatter.timeStyle = .short
//        let currentTime = formatter.string(from: now)
//        print("Current time:  \(currentTime)")
        
//        let midnight = Calendar.current.date(bySettingHour: 11, minute: 59, second: 59, of: Date())
//        print("Midnight time:  \(midnight)")
    }
    
    @IBAction func runCode(sender: UIButton){
        
    }
    
    
    func inputfitnessDataForWater(fd: fitnessDataWaterClass){
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
    } // end of maindb info func
    
    @objc func waterVCLogoClick(gesture: UIGestureRecognizer){
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
    
    func getWaterPercentage(){
        inputfitnessDataForWater(fd: fitnessDataWater2Obj)
        todaysIntakeLabel.text = "Today's Intake: \(fitnessDataWater2Obj.yourWater2[0]) of \(fitnessDataWater2Obj.water2[0]) Oz."
        var waterPercentage = 0.0
        print("You current water: \(fitnessDataWater2Obj.yourWater2[0])")
        if((fitnessDataWater2Obj.yourWater2[0]) > 0){
            waterPercentage = (Double(fitnessDataWater2Obj.yourWater2[0]))/(Double(fitnessDataWater2Obj.water2[0]))
        }else{
            waterImage.image = UIImage(named: "water0")
        }
        waterPercentage *= 100
        print("You water percentage is: \(waterPercentage)%")
        if(waterPercentage > 0 && waterPercentage <= 10){
            waterImage.image = UIImage(named: "water1")
        }else if(waterPercentage > 10 && waterPercentage <= 20){
            waterImage.image = UIImage(named: "water2")
        }else if(waterPercentage > 20 && waterPercentage <= 30){
            waterImage.image = UIImage(named: "water3")
        }else if(waterPercentage > 30 && waterPercentage <= 40){
            waterImage.image = UIImage(named: "water4")
        }else if(waterPercentage > 40 && waterPercentage <= 50){
            waterImage.image = UIImage(named: "water5")
        }else if(waterPercentage > 50 && waterPercentage <= 60){
            waterImage.image = UIImage(named: "water6")
        }else if(waterPercentage > 60 && waterPercentage <= 70){
            waterImage.image = UIImage(named: "water7")
        }else if(waterPercentage > 70 && waterPercentage <= 80){
            waterImage.image = UIImage(named: "water8")
        }else if(waterPercentage > 80 && waterPercentage <= 100){
            waterImage.image = UIImage(named: "water9")
        }
    } //end of get water percentage
    
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
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(NewViewController.backButtonClick(gesture:)))
                backButton.addGestureRecognizer(tapGesture2)
                backButton.isUserInteractionEnabled = true
         waterVCLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewViewController.waterVCLogoClick(gesture:)))
        waterVCLogo.addGestureRecognizer(tapGesture)
        waterVCLogo.isUserInteractionEnabled = true
        mainDBInfo()
        getWaterPercentage()
//        findDate()
        //when veiw laods query fitnesss data and get percentage to determine which image to use
    }
    

   
    

}
