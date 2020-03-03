//
//  DataController.swift
//  MiniProjet
//
//  Created by ELAZMI Mouna on 2/7/20.
//  Copyright © 2020 ELAZMI Mouna. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer

    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }

    let backgroundContext:NSManagedObjectContext!

    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name:modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }

    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    func load(completion : (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            //self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }

    func saveContext() {
        if viewContext.hasChanges{
            try? viewContext.save()
        }

    }

    func fetch<T: NSManagedObject>(_ objectType : T.Type) -> [T] {
        let entityName = String(describing : objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do{
           let fetchedObject = try viewContext.fetch(fetchRequest) as? [T]
            return fetchedObject ?? [T]()
        }
        catch{
            print("Error while fetching")
            return [T]()
        }
    }
}

extension DataController{

    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")

        guard interval > 0 else {
            return
        }

        if viewContext.hasChanges{
            try? viewContext.save()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + interval){
            self.autoSaveViewContext(interval: interval)
        }
    }
}
