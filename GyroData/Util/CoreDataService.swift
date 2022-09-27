//
//  CoreDataService.swift
//  GyroData
//
//  Created by 홍다희 on 2022/09/27.
//

import Foundation
import CoreData

class CoreDataService {
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?

    init(
        with persistentContainer: NSPersistentContainer,
        fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    ) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }

    lazy var fetchedResultsController: NSFetchedResultsController<CDMotionData> = {
        let fetchRequest: NSFetchRequest<CDMotionData> = CDMotionData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDMotionData.date), ascending: true)]
        fetchRequest.fetchBatchSize = 10
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = fetchedResultsControllerDelegate
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        return controller
    }()
    
    func add(
        _ motionData: GyroData,
        context: NSManagedObjectContext,
        shouldSave: Bool = true,
        completion: ((Error?) -> Void)? = nil
    ) {
        context.perform {
            let entity = CDMotionData(context: context)
            entity.date = motionData.date
            entity.type = Int16(motionData.type.rawValue)
            entity.lastTick = motionData.lastTick
            entity.items = NSSet(
                array: motionData.items.map {
                    let item = CDMotionDataItem(context: context)
                    item.tick = $0.tick
                    item.x = $0.x
                    item.y = $0.y
                    item.z = $0.z
                    return item
                }
            )

            if shouldSave {
                do {
                    try context.save()
                    completion?(nil)
                } catch {
                    completion?(error)
                }
            }
        }
    }

    func delete(
        _ motionData: CDMotionData,
        shouldSave: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let context = motionData.managedObjectContext else {
            fatalError(#function + String(describing: motionData))
        }
        context.perform {
            context.delete(motionData)

            if shouldSave {
                do {
                    try context.save()
                    completion?()
                } catch {
                    print(#function, error)
                }
            }
        }
    }
}
