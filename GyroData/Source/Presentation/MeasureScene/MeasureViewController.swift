//
//  MeasureViewController.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/01/31.
//

import UIKit

class MeasureViewController: UIViewController {
    private enum Constant {
        static let title = "측정하기"
        static let rightBarButtonItemTitle = "저장"
        static let margin = CGFloat(16)
        static let saveFailAlertTitle = "저장 실패"
        static let saveFailAlertActionTitle = "확인"
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            Sensor.accelerometer.description,
            Sensor.gyroscope.description
        ])
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let graphView: GraphView = {
        let graphView = GraphView(interval: 0.1, duration: 60)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        return graphView
    }()
    
    private let viewModel: MeasureViewModel
    
    init(viewModel: MeasureViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setViewModelDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSegmentControl()
    }
}

private extension MeasureViewController {
    func setViewModelDelegate() {
        self.viewModel.delegate = self
    }
    
    func setupNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(
            title: Constant.rightBarButtonItemTitle,
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.title = Constant.title
    }
    
    func setupSegmentControl() {
        view.addSubview(segmentedControl)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.margin),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.margin),
        ])
    }
}

// MARK: - objc Method
extension MeasureViewController {
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        let segment = segmentedControl.selectedSegmentIndex
        viewModel.action(.sensorTypeChanged(sensorType: Sensor(rawValue: segment)))
    }
}

extension MeasureViewController: MeasureViewDelegate {
    func updateValue(_ values: Values) {
        graphView.drawData(data: values)
    }
    
    func nonAccelerometerMeasurable() {
        
    }
    
    func nonGyroscopeMeasurable() {
        
    }
    
    func endMeasuringData() {
        
    }
    
    func saveSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveFail(_ error: Error) {
        let alertController = UIAlertController(
            title: Constant.saveFailAlertTitle,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(
            title: Constant.saveFailAlertActionTitle,
            style: .default
        )
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true)
    }
    
    
}


import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        let service = SensorMeasureService()
        let viewModel = MeasureViewModel(measureService: service)
        
        MeasureViewController(viewModel: viewModel).toPreview()
    }
}


#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
