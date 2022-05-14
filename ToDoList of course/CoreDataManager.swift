//
//  CoreDataManager.swift
//  ToDoList of course
//
//  Created by Никита Бутовцов on 14.05.2022.
//

import UIKit
import CoreData

class CoreDataManager {
    
    // сохраняем контекст
    func saveContext(context: NSManagedObjectContext, tableView: UITableView) {
        
        do {
            try context.save()
        } catch {
            print("error saving context")
        }
        
        tableView.reloadData()
    }
}


