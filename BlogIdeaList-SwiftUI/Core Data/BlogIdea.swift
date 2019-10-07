//
//  BlogIdea.swift
//  BlogIdeaList-SwiftUI
//
//  Created by Andrew Bancroft on 7/30/19.
//  Copyright © 2019 Andrew Bancroft. All rights reserved.
//
// ❇️ Alerts you to Core Data pieces
// ℹ️ Alerts you to general info about what my brain was thinking when I wrote the code
//

import Foundation
import CoreData

// ❇️ BlogIdea code generation is turned OFF in the xcdatamodeld file
public class BlogIdea: NSManagedObject, Identifiable {
    @NSManaged public var ideaTitle: String?
    @NSManaged public var ideaDescription: String?
}

extension BlogIdea {
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func allIdeasFetchRequest() -> NSFetchRequest<BlogIdea> {
        let request: NSFetchRequest<BlogIdea> = BlogIdea.fetchRequest() as! NSFetchRequest<BlogIdea>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "ideaTitle", ascending: true)]
          
        return request
    }
}

// ❇️ Create Read Update Destroy
extension BlogIdea {
    
    public static func create(_ ideaTitle: String,
                              ideaDescription: String,
                              context: NSManagedObjectContext) -> Result<BlogIdea, Error> {
        let idea = BlogIdea(context: context)
        idea.ideaTitle = ideaTitle
        idea.ideaDescription = ideaDescription
        return Result(catching: {try context.save()}).flatMap { _ in
            Result.success(idea)
        }
    }
    
    public static func update(_ ideaToUpdate: BlogIdea,
                              updatedIdeaTitle: String?,
                              updatedIdeaDescription: String?,
                              context: NSManagedObjectContext) -> Result<BlogIdea, Error> {
        ideaToUpdate.objectWillChange.send()
        ideaToUpdate.ideaTitle = updatedIdeaTitle
        ideaToUpdate.ideaDescription = updatedIdeaDescription
        return Result(catching: {try context.save()}).flatMap { _ in
            Result.success(ideaToUpdate)
        }
    }
    
    // ❇️ This is more for show than to be used
    public static func read(_ id: NSManagedObjectID,
                              context: NSManagedObjectContext) -> Result<BlogIdea, Error> {
        if let object = context.object(with: id) as? BlogIdea{
            return Result.success(object)
        } else {
            return Result.failure(NSError())// better to use a custom type but it isn't what I'm teaching
        }
    }
    
    public static func delete(_ blogIdeaToDelete: BlogIdea,
                              context: NSManagedObjectContext) -> Result<Void, Error> {
        context.delete(blogIdeaToDelete)
        return Result(catching: {try context.save()})
    }
}
