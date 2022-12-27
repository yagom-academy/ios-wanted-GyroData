//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class MeasurementViewController: UIViewController {
    private let measurementView = MeasurementView()
    
    override func loadView() {
        view = measurementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
