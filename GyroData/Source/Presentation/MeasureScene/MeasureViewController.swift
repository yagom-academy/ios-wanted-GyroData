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
        // TODO: - 저장 버튼
    }
}
