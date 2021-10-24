//
//  AddNotesViewController.swift
//  MinimalToDoApp
//
//  Created by Ersan Çetin on 24.10.2021.
//

import UIKit
import CoreData

class AddNotesViewController: UIViewController {
    
    @IBOutlet weak var iconText: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var noteText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func clickSaveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
        
        newNote.setValue(datePicker.date, forKey: "date")
        newNote.setValue(iconText.text, forKey: "icon")
        newNote.setValue(noteText.text, forKey: "note")
        newNote.setValue(false, forKey: "done")
        newNote.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        } catch {
            print("contex.save error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
