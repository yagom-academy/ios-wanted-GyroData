//
//  MeasureViewController.swift
//  GyroData
//
//  Created by sole on 2022/09/24.
//

import UIKit

final class MeasureViewController: UIViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    private let segmentControl: UISegmentedControl = {
        let items = MotionType.allCases.map { $0.displayText }
        let control = UISegmentedControl(items: items)
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
        return view
    }()
    
    private lazy var measureButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapMeasureButton), for: .touchUpInside)
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isEnabled = true
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        button.setTitle("정지", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.isEnabled = false
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(didTapSaveButton))
    
    private let coreMotionService = CoreMotionService()

    private lazy var coreDataService: CoreDataService = {
        let container = appDelegate.coreDataStack.persistentContainer
        return CoreDataService(with: container, fetchedResultsControllerDelegate: nil)
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
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        view.backgroundColor = .systemBackground

        [
            segmentControl,
            graphView,
            measureButton,
            stopButton,
            UIView(),
        ].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        let inset: CGFloat = 16
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inset),

            segmentControl.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            graphView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            graphView.heightAnchor.constraint(lessThanOrEqualTo: graphView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor).withPriority(.defaultLow - 1),
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
        DispatchQueue.main.async {
            self.graphView.realtimeData.append(data)
        }
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
