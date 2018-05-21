//
//  TodoListViewController.swift
//  Demo
//
//  Created by Roy Hsu on 2018/5/21.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - TodoListViewController

import UIKit

class TodoListViewController: UITableViewController {
    
    var todos: [Todo] = []
    
    var todoProvider: TodoProvider?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let addBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTodo)
        )
        
        addBarButtonItem.isEnabled = false
        
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        todoProvider?.loadStore(name: "Main") { result in
        
            switch result {
                
            case .success: addBarButtonItem.isEnabled = true

            case let .failure(error): self.showAlert(message: error.localizedDescription)
                
            }
        
        }

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
                    let title = titleTextField?.text,
                    !title.isEmpty
                else {
                    
                    self.showAlert(message: "Please enter the title.")
                    
                    return
                        
                }
                
                self.todoProvider?.createTodo(title: title) { result in
                    
                    switch result {
                        
                    case .success:
                        
                        self.todoProvider?.readTodos { result in
                            
                            switch result {
                                
                            case let .success(todos):
                                
                                self.todos = todos
                           
                                self.tableView.reloadData()
                                
                            case let .failure(error): self.showAlert(message: error.localizedDescription)
                        
                            }
                            
                        }
                        
                    case let .failure(error): self.showAlert(message: error.localizedDescription)
                    
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
