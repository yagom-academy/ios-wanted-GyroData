//
//  RecordGyroViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit
import CoreMotion

final class RecordGyroViewController: UIViewController {
    private let gyroRecorder = GyroRecorder.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
    }
}
