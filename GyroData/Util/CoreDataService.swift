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
        fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? = nil
    ) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsController = fetchedResultsController
    }

    lazy var fetchedResultsController: NSFetchedResultsController<CDMotionData> = {
        let fetchRequest: NSFetchRequest<CDMotionData> = CDMotionData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDMotionData.date), ascending: true)]
        fetchRequest.fetchBatchSize = 10 // TODO: 알아보기
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil, cacheName: nil
        )
        controller.delegate = fetchedResultsControllerDelegate

        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }

        return controller
    }()
}
