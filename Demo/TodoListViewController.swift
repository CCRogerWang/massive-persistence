//
//  TodoListViewController.swift
//  Demo
//
//  Created by Roy Hsu on 2018/5/21.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - TodoListViewController

import CoreData
import UIKit

class TodoListViewController: UITableViewController {
    
    var persistentContainer: NSPersistentContainer?
    
    var todos: [TodoEntity] = []
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let addBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTodo)
        )
        
        addBarButtonItem.isEnabled = false
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        let container = NSPersistentContainer(name: "Main")
        
        let description = NSPersistentStoreDescription()
        
        // Development only.
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [ description ]
        
        container.loadPersistentStores { description, error in
            
            if let error = error {
                
                self.showAlert(message: error.localizedDescription)
                
                return
                
            }
            
            addBarButtonItem.isEnabled = true
        
        }
        
        persistentContainer = container

    }
    
    func showAlert(message: String) {
        
        let alertController = UIAlertController(
            title: "Oops! Something went wrong.",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(okAction)
        
        present(
            alertController,
            animated: true,
            completion: nil
        )
        
    }
    
    // MARK: Action
    
    @objc
    func addTodo(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "New Todo",
            message: nil,
            preferredStyle: .alert
        )
        
        var titleTextField: UITextField?
        
        alertController.addTextField { textField in
            
            textField.placeholder = "Title"
            
            titleTextField = textField
            
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        alertController.addAction(cancelAction)
        
        let addAction = UIAlertAction(
            title: "Add",
            style: .default,
            handler: { _ in
                
                guard
                    let container = self.persistentContainer
                else { fatalError("Must set a persistent container.") }
                
                guard
                    let title = titleTextField?.text,
                    !title.isEmpty
                else {
                    
                    self.showAlert(message: "Please enter the title.")
                    
                    return
                        
                }

                container.performBackgroundTask { backgroundContext in
                    
                    guard
                        let description = NSEntityDescription.entity(
                            forEntityName: "Todo",
                            in: backgroundContext
                        )
                    else { fatalError("CANNOT find the entity description for Todo.") }
                    
                    backgroundContext.perform {
                        
                        let todo = TodoEntity(
                            entity: description,
                            insertInto: backgroundContext
                        )
                        
                        todo.title = title
                        
                        todo.createdAtDate = Date()
                        
                        do {
                            
                            try backgroundContext.save()
                            
                            container.viewContext.perform {
                                
                                let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                                
                                fetchRequest.sortDescriptors = [
                                    NSSortDescriptor(
                                        key: "createdAtDate",
                                        ascending: false
                                    )
                                ]
                                
                                do {
                                    
                                    let todos = try container.viewContext.fetch(fetchRequest)
                                    
                                    self.todos = todos
                                    
                                    self.tableView.reloadData()
                                    
                                }
                                catch { self.showAlert(message: error.localizedDescription) }
                                
                            }
                            
                        }
                        catch { self.showAlert(message: error.localizedDescription) }
                        
                    }
                    
                }
                
            }
        )
        
        alertController.addAction(addAction)
        
        present(
            alertController,
            animated: true,
            completion: nil
        )
        
    }
 
    // MARK: UITableViewDataSource
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    )
    -> Int { return todos.count }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    )
    -> UITableViewCell {
        
        let cell = UITableViewCell(
            style: .default,
            reuseIdentifier: nil
        )
        
        let todo = todos[indexPath.row]
        
        cell.textLabel?.text = todo.title
        
        return cell
        
    }
    
}
