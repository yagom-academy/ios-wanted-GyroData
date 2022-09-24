//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    let test = Measure(title: "test", second: 0.32)
    let test2 = Measure(title: "haha", second: 0.9999)
    let manager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        print("⭐️insert")
        manager.insertMeasure(measure: test)
        manager.insertMeasure(measure: test2)
        
        let data = manager.fetch()
        print("💨fetch", data)
        

        guard let count = manager.count() else { return }
        print("🎉count", count)
        
        print("❌ delete")
        manager.delete(object: data.last!)
        
        guard let count = manager.count() else { return }
        print("🎉count", count)
        
        manager.deleteAll()
        let data2 = manager.fetch()
        if data2.isEmpty {
            print("👏🏻 clean!!")
        }
        
        guard let count = manager.count() else { return }
        print("🎉count", count)
        
        
    }


}

