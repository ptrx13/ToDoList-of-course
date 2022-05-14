//
//  ViewController.swift
//  ToDoList of course
//
//  Created by Никита Бутовцов on 10.05.2022.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var coreDataManager = CoreDataManager()
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        coreDataManager.saveContext(context: context, tableView: tableView)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //self.saveItems()
        coreDataManager.saveContext(context: context, tableView: tableView)
    }
    
    // MARK: - Add item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Новая задача", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.coreDataManager.saveContext(context: self.context, tableView: self.tableView)
        }
        
        alert.addTextField { (alertTF) in
            alertTF.placeholder = "Добавить новую задачу"
            textField = alertTF
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Load items
    
    // выгружаем данные
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("\(error)")
        }
    }
}
