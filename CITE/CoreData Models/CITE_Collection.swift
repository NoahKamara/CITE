//
//  CITE_Collection.swift
//  CITE
//
//  Created by Noah Kamara on 18.07.20.
//
//

import Foundation
import CoreData
import SwiftUI


@objc(CITE_Collection)
public class CITE_Collection: NSManagedObject {
    
}

extension CITE_Collection {
    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<CITE_Collection> {
//        return NSFetchRequest<CITE_Collection>(entityName: "CITE_Collection")
//    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var label: String?
    @NSManaged public var type: String?
    @NSManaged public var color: UIColor?
    @NSManaged public var folderItems: NSSet?
    @NSManaged public var tagItems: NSSet?
    
}

extension CITE_Collection {
    static func getAll() -> NSFetchRequest<CITE_Collection> {
        let request: NSFetchRequest<CITE_Collection> = CITE_Collection.fetchRequest() as! NSFetchRequest<CITE_Collection>
        request.sortDescriptors = []
        return request
    }
    
    static func getFolders() -> NSFetchRequest<CITE_Collection> {
        let request: NSFetchRequest<CITE_Collection> = CITE_Collection.fetchRequest() as! NSFetchRequest<CITE_Collection>
        let predicate: NSPredicate = NSPredicate(format: "type == %@", "folder")
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    static func getTags() -> NSFetchRequest<CITE_Collection> {
        let request: NSFetchRequest<CITE_Collection> = CITE_Collection.fetchRequest() as! NSFetchRequest<CITE_Collection>
        let predicate: NSPredicate = NSPredicate(format: "type == %@", "tag")
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}


// MARK: Generated accessors for folderItems
extension CITE_Collection {
    
    @objc(addFolderItemsObject:)
    @NSManaged public func addToFolderItems(_ value: CITE_Collection)
    
    @objc(removeFolderItemsObject:)
    @NSManaged public func removeFromFolderItems(_ value: CITE_Collection)
    
    @objc(addFolderItems:)
    @NSManaged public func addToFolderItems(_ values: NSSet)
    
    @objc(removeFolderItems:)
    @NSManaged public func removeFromFolderItems(_ values: NSSet)
    
}

// MARK: Generated accessors for tagItems
extension CITE_Collection {
    
    @objc(addTagItemsObject:)
    @NSManaged public func addToTagItems(_ value: CITE_Collection)
    
    @objc(removeTagItemsObject:)
    @NSManaged public func removeFromTagItems(_ value: CITE_Collection)
    
    @objc(addTagItems:)
    @NSManaged public func addToTagItems(_ values: NSSet)
    
    @objc(removeTagItems:)
    @NSManaged public func removeFromTagItems(_ values: NSSet)
    
}

extension UIColor {
    class func color(withData data:Data) -> UIColor {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}
