//
//  ViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit
import CoreMotion

final class ViewController: UIViewController {
    private let gyroManager = GyroManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
    }
}
