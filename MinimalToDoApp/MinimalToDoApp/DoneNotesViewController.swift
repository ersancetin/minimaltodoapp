//
//  DoneNotesViewController.swift
//  MinimalToDoApp
//
//  Created by Ersan Çetin on 24.10.2021.
//

import UIKit
import CoreData

class DoneNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var iconArray = [String]()
    var noteArray = [String]()
    var idArray = [UUID]()
    var dateArray = [Date]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // get core data
        
        getData()
    }
    
    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        //
        
        fetchRequest.predicate = NSPredicate(format: "done == %@", NSNumber(booleanLiteral: false))
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let note = result.value(forKey: "note") as? String{
                    noteArray.append(note)
                }
                if let icon = result.value(forKey: "icon") as? String{
                    iconArray.append(icon)
                }
                if let date = result.value(forKey: "date") as? Date{
                    dateArray.append(date)
                }
                
            }
            
        } catch {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateArray[indexPath.row]
        let dateString = dateFormatter.string(from: date)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "costumCellModel", for: indexPath) as! CostumTableViewCell
        cell.noteLabel.text = noteArray[indexPath.row]
        cell.iconLabel.text = iconArray[indexPath.row]
        cell.dateLabel.text = dateString
        let rowNumber = String(indexPath.row + 1)
        cell.listNoLabel.text = rowNumber
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteArray.count
    }

}
