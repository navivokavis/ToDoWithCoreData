//
//  MainViewController.swift
//  ToDoWithCoreData
//
//  Created by Navi Vokavis on 14.11.22.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var tableView = UITableView()
    var plusButtonOnNavigationBar = UIBarButtonItem()
    var tasks: [Task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        deleteContext()
    }

    func setup() {
        buildHiererhy()
        configureSubviews()
        layoutSubviews()
    }
    
    func buildHiererhy() {
        view.addSubview(tableView)
    }
    
    func configureSubviews() {
        title = "ToDo"
        
        navigationController?.navigationBar.barStyle = .default
        
        plusButtonOnNavigationBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonOnNavigationBarTapped))
        
        navigationItem.rightBarButtonItem = plusButtonOnNavigationBar

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }
    
    func layoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        

    }
    
    //MARK: - objc func
    
    @objc func plusButtonOnNavigationBarTapped() {
        let alertController = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let tf = alertController.textFields?.first
            if tf?.text != "" {
                if let newTaskTitle = tf?.text {
//                    self.tasks.insert(newTask, at: 0)
                    self.saveTask(withTitle: newTaskTitle)
                    self.tableView.reloadData()
                }
            } else { return }
        }
        alertController.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    //MARK: - Save data in Core Data
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func saveTask(withTitle title: String) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - delete data from Core Data
    
    func deleteContext() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    
    
}

