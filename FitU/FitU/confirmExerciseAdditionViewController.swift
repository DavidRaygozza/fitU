//
//  confirmExerciseAdditionViewController.swift
//  FitU
//
//  Created by Library on 12/15/20.
//  Copyright © 2020 David Raygoza. All rights reserved.
//

import UIKit
import SQLite3
import Foundation

class confirmExerciseAdditionViewController: UIViewController {
    
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
    }

    @IBAction func yesButton(_ sender: Any) {
        
        //insert into user exercise query
        
        guard let userexercisevc = storyboard?.instantiateViewController(identifier: "userExercise_vc") as? userExerciseViewController else{
            print("couldnt find page")
            return
            }
        userexercisevc.modalPresentationStyle = .fullScreen
        present(userexercisevc, animated: true)
    }
    
    @IBAction func noButton(_ sender: Any) {
        guard let exercisevc = storyboard?.instantiateViewController(identifier: "exercise_vc") as? ExerciseViewController else{
            print("couldnt find page")
            return
            }
        exercisevc.modalPresentationStyle = .fullScreen
        present(exercisevc, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDBInfo()
    }
    

  

}
