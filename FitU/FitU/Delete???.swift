import UIKit
import SQLite3
import Foundation

class EnterFitnessDataViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var ftField: UITextField!
    @IBOutlet weak var ftLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var inField: UITextField!
    
    @IBOutlet weak var weightField: UILabel!
    @IBOutlet weak var ageField: UILabel!
    
    @IBOutlet weak var activityField: UILabel!
    @IBOutlet weak var weightSliderO: UISlider!
    @IBOutlet weak var genderField: UISegmentedControl!
    @IBOutlet weak var ageSliderO: UISlider!
    
    
    @IBAction func weightSliderChange(_ sender: Any) {
        weightField.text = "\(Int(floor(Float(weightSliderO.value)))) lbs."
    }
    
    @IBAction func ageSliderChange(_ sender: Any) {
        ageField.text = "\(Int(floor(Float(ageSliderO.value))))"
    }
    
    
    @IBAction func enterFitnessDataButton(_ sender: Any) {
//        if(genderField.selectedSegmentIndex == 0){
//            var gen = "Male"
//        }else if(genderField.selectedSegmentIndex == 1){
//            var gen = "Female"
//        }
        //run query here
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    } //end of view did load
   
} // end of super main class
