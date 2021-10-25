//
//  ViewController.swift
//  MinimalToDoApp
//
//  Created by Ersan Çetin on 24.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var iconArray = [String]()
    var noteArray = [String]()
    var idArray = [UUID]()
    var dateArray = [Date]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Add Note", style: .plain, target: self, action: #selector(clickAddButton))
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(clickDoneButton))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    //notification center for add new not and come back
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    //get core data func
    
    @objc func getData(){
        
        //remove all list before get core data
        //mükerrer eleman çekilmesi gündeme gelecek
        //her çektiğinde listeye ekleyecek çünkü
        
        noteArray.removeAll(keepingCapacity: false)
        iconArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        dateArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let note = result.value(forKey: "note") as? String{
                    self.noteArray.append(note)
                }
                if let icon = result.value(forKey: "icon") as? String{
                    self.iconArray.append(icon)
                }
                if let id = result.value(forKey: "id") as? UUID{
                    self.idArray.append(id)
                }
                if let date = result.value(forKey: "date") as? Date{
                    self.dateArray.append(date)
                }
            }
            self.tableView.reloadData()
            
            print("success fetch request")
        } catch {
            print("fetch request error")
        }
    }

    //tableview default
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //date to string casting with date formatter .string method
        
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
        return noteArray.count
    }
    
    //button
    
    @objc func clickAddButton(){
        performSegue(withIdentifier: "toAddNoteVC", sender: nil)
    }

    @objc func clickDoneButton(){
        performSegue(withIdentifier: "toDoneVC", sender: nil)
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@ ", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
          

          
            self.tableView.reloadData()
          
        }
    }

}

