//
//  MotionMeasurementViewController.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.


import UIKit

final class MotionMeasurementViewController: UIViewController {
    private enum Literals {
        static let accelerometer = "Accelerometer"
        static let gyro = "Gyro"
        static let start = "Start"
        static let stop = "Stop"
        static let rightNavigationItem = "저장"
    }
    
    private enum Selection {
        case accelerometer
        case gyro
        
        var value: Int {
            switch self {
            case .accelerometer: return 0
            case .gyro: return 1
            }
        }
    }
    
    var viewModel: MotionMeasurementViewModel?
    private var selectedSegmentControlItem: Selection {
        switch measureTypeControl.selectedSegmentIndex {
        case Selection.gyro.value: return .gyro
        default: return .accelerometer
        }
    }
    
    // MARK: View(s)
    
    private let measureTypeControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [
            Literals.accelerometer,
            Literals.gyro
        ])
        segmentControl.selectedSegmentIndex = Selection.accelerometer.value
        segmentControl.backgroundColor = .systemGreen
        return segmentControl
    }()
    private let graphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .systemBlue
        return view
    }()
    private let startMeasureButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemYellow
        button.setTitle(Literals.start, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    private let stopMeasureButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray5
        button.setTitle(Literals.stop, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
    private let graphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        combineViews()
        configureViewConstraints()
        configureNavigationItems()
        addButtonActions()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel?.request(.stopTrackAcceleration)
        viewModel?.request(.stopTrackGyro)
    }
    
    // MARK: Private Function(s)
    
    private func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.bind { response in
            guard let data = response.receivedMotionData?.z else { return }
            DispatchQueue.main.async {
                self.graphView.addGraphLine(y: data)
            }
        }
    }
    
    private func configureNavigationItems() {
        let rightNavigationItem = UIBarButtonItem(
            title: Literals.rightNavigationItem,
            style: .plain,
            target: self,
            action: #selector(save)
        )
        navigationItem.rightBarButtonItem = rightNavigationItem
    }
    
    private func addButtonActions() {
        startMeasureButton.addTarget(self, action: #selector(start), for: .touchDown)
        stopMeasureButton.addTarget(self, action: #selector(stop), for: .touchDown)
    }
    
    private func combineViews() {
        let buttonViews: [UIView] = [
            startMeasureButton,
            stopMeasureButton
        ]
        let graphViews: [UIView] = [
            measureTypeControl,
            graphView
        ]
        let contentViews: [UIView] = [
            graphStackView,
            buttonsStackView
        ]
        
        graphStackView.addMultipleArrangedSubviews(views: graphViews)
        buttonsStackView.addMultipleArrangedSubviews(views: buttonViews)
        contentsStackView.addMultipleArrangedSubviews(views: contentViews)
        view.addSubview(contentsStackView)
    }
    
    private func configureViewConstraints() {
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
                ),
            contentsStackView.leadingAnchor
                .constraint(
                    equalTo: view.leadingAnchor
                ),
            contentsStackView.trailingAnchor
                .constraint(
                    equalTo: view.trailingAnchor
                )
        ])
        
        NSLayoutConstraint.activate([
            graphView.widthAnchor
                .constraint(
                    equalTo: view.widthAnchor,
                    multiplier: 0.9
                ),
            graphView.heightAnchor
                .constraint(
                    equalTo: graphView.widthAnchor
                )
        ])
        
        NSLayoutConstraint.activate([
            measureTypeControl.widthAnchor
                .constraint(
                    equalTo: graphView.widthAnchor
                )
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.widthAnchor
                .constraint(
                    equalTo: graphView.widthAnchor
                ),
            buttonsStackView.heightAnchor
                .constraint(
                    equalTo: graphView.heightAnchor,
                    multiplier: 0.2
                )
        ])
    }
    
    @objc
    func save() {
        viewModel?.request(.stopTrackAcceleration)
        viewModel?.request(.stopTrackGyro)
        viewModel?.request(.save)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func start() {
        switch selectedSegmentControlItem {
        case .accelerometer:
            viewModel?.request(.startTrackAcceleration)
        case .gyro:
            viewModel?.request(.startTrackGyro)
        }
        startMeasureButton.isEnabled.toggle()
        stopMeasureButton.isEnabled.toggle()
    }
    
    @objc
    func stop() {
        switch selectedSegmentControlItem {
        case .accelerometer:
            viewModel?.request(.stopTrackAcceleration)
        case .gyro:
            viewModel?.request(.stopTrackGyro)
        }
        startMeasureButton.isEnabled.toggle()
        stopMeasureButton.isEnabled.toggle()
    }
}
