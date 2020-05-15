//
//  ViewController.swift
//  Mezotasks
//
//  Created by Dave on 5/13/20.
//  Copyright © 2020 DoItMem. All rights reserved.
//

import UIKit

class ViewController: ToDoParent {

    @IBOutlet weak var taskTitle: UITextField!
   
    @IBOutlet weak var taskText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    @IBAction func addTasks(_ sender: Any) {
        
        if taskTitle.text != "" {
          if let context = self.context{
              let todo = ToDo(context: context)
              let title = taskTitle.text
              let details = taskText.text
              
              // Nil todos can't be added
              if let title = title{
                  todo.title = title
                  todo.detail = details
                  
                  self.todoList.append(todo)
                  
                  do{
                      try context.save()
                  }catch{
                      fatalError("Error storing data")
                  }
              }
          }
        }
        else {
            let alert = UIAlertController(title: "Empty Task", message: "Please write title of the task", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
        taskTitle.text = ""
        taskText.text = ""
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

