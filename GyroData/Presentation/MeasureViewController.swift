//
//  MeasureViewController.swift
//  GyroData
//
//  Created by bonf, seohyeon2 on 2022/12/26.
//

import UIKit

class MeasureViewController: UIViewController {
    
    let measureView = MeasureView()
    let measurementService = MeasurementService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = measureView
        view.backgroundColor = .white
        
        self.navigationItem.title = "측정하기"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: nil,
            action: nil
        )
        bind()
        
        registMeasureButtonAction()
        registStopButtonAction()
    }
    
    private func registMeasureButtonAction() {
        measureView.measurementButton.addTarget(
            self,
            action: #selector(measure),
            for: .touchUpInside
        )
    }
    
    private func registStopButtonAction() {
        measureView.stopButton.addTarget(
            self,
            action: #selector(stop),
            for: .touchUpInside)
    }
    
    @objc private func measure() {
        measureView.measurementSegmentedControl.isEnabled = false
        measureView.chartsView.setupDefaultValue()
        
        if measureView.measurementSegmentedControl.selectedSegmentIndex == 0 {
            measurementService.measureAccelerometer()
        } else if measureView.measurementSegmentedControl.selectedSegmentIndex == 1 {
            measurementService.measureGyro()
        }
    }
    
    @objc private func stop() {
        measureView.measurementSegmentedControl.isEnabled = true
        measurementService.stopMeasurement()
    }
    
    private func bind() {
        measurementService.accCoordinates.subscribe { coordinates in
            guard let lastCoordinate = coordinates.last else { return }
            self.measureView.chartsView.drawChart(x: lastCoordinate.x, y: lastCoordinate.y, z: lastCoordinate.z)
                    
            let strX = String(format: "%.1f", lastCoordinate.x)
            let strY = String(format: "%.1f", lastCoordinate.y)
            let strZ = String(format: "%.1f", lastCoordinate.z)
            
            self.measureView.chartsView.configureLabelText(x: strX, y: strY, z: strZ)
        }
    }
}
