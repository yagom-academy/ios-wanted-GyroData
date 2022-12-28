//
//  CoreDataManager.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/27.
//

import UIKit
import CoreData

struct CoreDataManager {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func save(date: Motion) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        
        let coreData = MotionEntity(context: context)
        coreData.date = date.date
        coreData.measurementType = date.measurementType
        coreData.coordinate = date.coordinate

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetch() -> [Motion] {
        var motions: [Motion] = []
        if let context = appDelegate?.persistentContainer.viewContext {
            do {
                let contact = try context.fetch(MotionEntity.fetchRequest()) as? [MotionEntity]
                contact?.forEach {
                    let motion = Motion(date: $0.date ?? "",
                                        measurementType: $0.measurementType ?? "",
                                        coordinate: $0.coordinate ?? Coordinate(x: [], y: [], z: []))
                    motions.append(motion)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return motions
    }
}
