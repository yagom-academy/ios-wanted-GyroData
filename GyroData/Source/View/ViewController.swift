//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        b()
    }
    
    
    func b() {
        let filemanager = FileHandleManager()
        do {
            try filemanager?.delete(fileName: UUID(uuidString: "B6D082BD-3095-4B94-8DE4-35CE5B501F22")!)
        } catch {
            print("failed")
        }
        
    }


}

