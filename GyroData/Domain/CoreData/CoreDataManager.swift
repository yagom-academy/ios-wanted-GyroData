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
    
    func saveData() {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "MotionEntity", in: context)
        
        let coordinate = Coordinate(x: [3], y: [2], z: [1])
        
        if let entity = entity {
            let data = NSManagedObject(entity: entity, insertInto: context)
            data.setValue("2020/12/27", forKey: "date")
            data.setValue("안녕하시라요", forKey: "measurementType")
            data.setValue(coordinate, forKey: "coordinate")
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchData() -> [Motion] {
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
