//
//  Task+CoreDataProperties.swift
//  ToDoWithCoreData
//
//  Created by Navi Vokavis on 15.11.22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?

}

extension Task : Identifiable {

}
