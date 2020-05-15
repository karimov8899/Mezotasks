//
//  TodoVC.swift
//  ListTodo
//
//  Created by Muhammad Moaz Khan on 16/03/2018.
//  Copyright © 2018 MK. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: ToDoParent{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // context from app delegate singleton
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        // load todo list data
        if loadData(){
            tableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if loadData(){
            tableView.reloadData()
        }
    }
     
    
    override func loadData()->Bool{
        if super.loadData(){
            return true
        }
        return false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegueId"{
            let detailVC = segue.destination as? DetailVC
            let row = sender as? Int
            if let detailVC = detailVC, let row = row{
                detailVC.titleText = todoList[row].title
                detailVC.detailText = todoList[row].detail
            }
        }
    }
}

// MARK: - Extension for tableview methods
extension ToDoVC: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoItemCell
        cell.title.text = todoList[indexPath.item].title
        let chevron = UIImage(named: "chevron.png")
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: chevron!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

         let noteEntity = "ToDo"
         let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

         let note = todoList[indexPath.row]

         if editingStyle == .delete {
            managedContext.delete(note)

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }

         }

        //Code to Fetch New Data From The DB and Reload Table.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: noteEntity)
        
        do {
            todoList = try managedContext.fetch(fetchRequest) as! [ToDo]
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegueId", sender: indexPath.row)
    }
}
