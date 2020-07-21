//
//  CITE_Reference.swift
//  CITE
//
//  Created by Noah Kamara on 18.07.20.
//
//

import Foundation
import CoreData
import MobileCoreServices

@objc(CITE_Reference)
public class CITE_Reference: NSManagedObject, Identifiable, NSItemProviderWriting, NSItemProviderReading {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData as String)]
    }
    
    public static var readableTypeIdentifiersForItemProvider: [String] {
        return [(kUTTypeData as String)]
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        
        let data = self.id!.uuidString.data(using: .utf8)
        
        progress.completedUnitCount = 100
        completionHandler(data, nil)
        
        return progress
    }
    
    
    
    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let request: NSFetchRequest<CITE_Reference> = CITE_Reference.fetchRequest() as! NSFetchRequest<CITE_Reference>
        
        let id = UUID(uuidString: String(data: data, encoding: .utf8)!)
        request.predicate = NSPredicate(format: "id == %@", id! as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let results = try request.execute()
            if results.count == 1 {
                return results[0] as! Self
            } else {
                fatalError("Received more than one object")
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
    
    
}

extension CITE_Reference {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<CITE_Reference> {
//        return NSFetchRequest<CITE_Reference>(entityName: "CITE_Reference")
//    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var document: Data?
    @NSManaged public var folder: CITE_Collection?
    @NSManaged public var tags: NSSet?

    func hasTag(_ tag: CITE_Collection) -> Bool {
        let tags: [CITE_Collection] = self.tags?.allObjects as! [CITE_Collection]
        return tags.contains(tag)
    }
}

extension CITE_Reference {
    
    static func getAll() -> NSFetchRequest<CITE_Reference> {
        let request: NSFetchRequest<CITE_Reference> = CITE_Reference.fetchRequest() as! NSFetchRequest<CITE_Reference>
                
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    static func get(for collection: CITE_Collection) -> NSFetchRequest<CITE_Reference> {
        let request: NSFetchRequest<CITE_Reference> = CITE_Reference.fetchRequest() as! NSFetchRequest<CITE_Reference>
        
        var predicate: NSPredicate
        
        switch collection.type {
            case "folder": predicate = NSPredicate(format: "folder == %@", collection)
            case "tag": predicate = NSPredicate(format: "tags CONTAINS %@", collection)
            default: predicate = NSPredicate(format: "tags CONTAINS %@", collection)
        }
        request.predicate = predicate
        
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }

}

// MARK: Generated accessors for tags
extension CITE_Reference {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: CITE_Collection)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: CITE_Collection)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
