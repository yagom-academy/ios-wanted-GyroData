//
//  MeasureViewController.swift
//  GyroData
//
//  Created by sole on 2022/09/24.
//

import UIKit

final class MeasureViewController: UIViewController {
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private let graphView: GraphView = {
        let width = UIScreen.main.bounds.width - 32
        let height = width
        let view = GraphView(frame: CGRect(x: .zero, y: .zero, width: width, height: height))
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var measureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapMeasureButton), for: .touchUpInside)
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isEnabled = true
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        button.setTitle("정지", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isEnabled = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        return indicator
    }()
    
    private let coreMotionService = CoreMotionService()
    private let coreDataService: CoreDataService = {
        let container = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer
        return CoreDataService(with: container!, fetchedResultsControllerDelegate: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureViews()
        configureLayout()
    }
    
    private func configureNavigation() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentControl)
        view.addSubview(graphView)
        view.addSubview(measureButton)
        view.addSubview(stopButton)
        view.addSubview(activityIndicator)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            graphView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            measureButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            measureButton.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: measureButton.bottomAnchor, constant: 20),
            stopButton.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func didTapMeasureButton() {
        graphView.realtimeData.removeAll()
        let type = MotionType(rawValue: segmentControl.selectedSegmentIndex) ?? .acc
        coreMotionService.startMeasurement(of: type,
                                           completion: { self.changeButtonsState() }) { data in
            self.drawMotionData(data: data)
        }
    }
    
    @objc
    private func didTapStopButton() {
        let type = MotionType(rawValue: segmentControl.selectedSegmentIndex) ?? .acc
        coreMotionService.stopMeasurement(of: type)
    }
    
    private func changeButtonsState() {
        measureButton.isEnabled = !measureButton.isEnabled
        stopButton.isEnabled = !measureButton.isEnabled
        navigationItem.rightBarButtonItem?.isEnabled = measureButton.isEnabled
        segmentControl.isEnabled = measureButton.isEnabled
    }
    
    private func drawMotionData(data: MotionDetailData) {
        graphView.realtimeData.append(data)
    }
    
    @objc
    private func didTapSaveButton() {
        guard let motionData = coreMotionService.motionData else {
            presentAlertController(title: "저장실패", message: "측정된 데이터가 없습니다.")
            return
        }
        changeButtonsState()
        activityIndicator.startAnimating()
        let context = coreDataService.persistentContainer.viewContext
        coreDataService.add(motionData, context: context) { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.activityIndicator.stopAnimating()
                guard let error = error else {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.presentAlertController(title: "저장실패", message: error.localizedDescription)
            }
        }
    }
}

