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
    
    func save(data: Motion) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        
        let coreData = MotionEntity(context: context)
        coreData.date = data.date
        coreData.measurementType = data.measurementType
        coreData.motionX = data.motionX
        coreData.motionY = data.motionY
        coreData.motionZ = data.motionZ
        
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
                                        motionX: $0.motionX,
                                        motionY: $0.motionY,
                                        motionZ: $0.motionZ)
                    motions.append(motion)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return motions
    }
    
    func delete(data: Motion) {
        guard let context = appDelegate?.persistentContainer.viewContext,
              let coreDatalist = try? context.fetch(MotionEntity.fetchRequest()),
              let coreData = coreDatalist.filter({ $0.date == data.date }).first else {
            return
        }
        
        context.delete(coreData)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
