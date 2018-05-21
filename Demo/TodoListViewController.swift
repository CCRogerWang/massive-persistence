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
    
    var fetchResultsController: NSFetchedResultsController<Todo>?
    
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
            handler: { [weak self] _ in

                guard
                    let weakSelf = self
                else { return }
                
                guard
                    let container = weakSelf.persistentContainer
                else { fatalError("Must set a persistent container.") }
                
                guard
                    let title = titleTextField?.text,
                    !title.isEmpty
                else {
                    
                    weakSelf.showAlert(message: "Please enter the title.")
                    
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
                        
                        let todo = Todo(
                            entity: description,
                            insertInto: backgroundContext
                        )
                        
                        todo.title = title
                        
                        todo.createdAtDate = Date()
                        
                        do {
                            
                            try backgroundContext.save()
                            
                            container.viewContext.perform {
                                
                                let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
                                
                                fetchRequest.sortDescriptors = [
                                    NSSortDescriptor(
                                        key: "createdAtDate",
                                        ascending: false
                                    )
                                ]
                                
                                weakSelf.fetchResultsController = NSFetchedResultsController(
                                    fetchRequest: fetchRequest,
                                    managedObjectContext: container.viewContext,
                                    sectionNameKeyPath: nil,
                                    cacheName: nil
                                )
                                
                                do {
                                    
                                    try weakSelf.fetchResultsController?.performFetch()
                                    
                                    weakSelf.tableView.reloadData()
                                    
                                }
                                catch { weakSelf.showAlert(message: error.localizedDescription) }
                                
                            }
                            
                        }
                        catch { weakSelf.showAlert(message: error.localizedDescription) }
                        
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
    -> Int {
        
        let sectionInfo = fetchResultsController?.sections?[section]
        
        return sectionInfo?.numberOfObjects ?? 0
        
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    )
    -> UITableViewCell {
        
        let cell = UITableViewCell(
            style: .default,
            reuseIdentifier: nil
        )
        
        if let todo = fetchResultsController?.object(at: indexPath) {
        
            cell.textLabel?.text = todo.title
            
        }
        
        return cell
        
    }
    
}
