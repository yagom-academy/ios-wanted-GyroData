//
//  RecordMotionDataViewController.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import UIKit

final class RecordMotionDataViewController: UIViewController {
    enum Constant {
        enum Namespace {
            static let navigationTitle = "측정하기"
            static let rightBarButtonTitle = "저장"
            static let measure = "측정"
            static let stop = "정지"
            static let confirm = "확인"
        }
        
        enum Layout {
            static let stackSpacing: CGFloat = 8
        }
    }
    
    private let viewModel: RecordMotionDataViewModel
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constant.Layout.stackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let segmentedControl = UISegmentedControl()
    private let graphView: GraphView = {
        let graphView = GraphView()
        graphView.backgroundColor = .systemBackground
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.Namespace.measure, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        return button
    }()

    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.Namespace.stop, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.isEnabled = false
        return button
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    init(viewModel: RecordMotionDataViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureSegmentedControl()
        configureButtonActions()
        bind()
        configureActivityIndicator()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        graphView.drawGrid()
    }
    
    private func configureNavigationBar() {
        title = Constant.Namespace.navigationTitle
        navigationItem.rightBarButtonItem = configureRightBarButton()
    }
    
    private func configureRightBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: Constant.Namespace.rightBarButtonTitle,
            primaryAction: saveButtonAction()
        )
    }
    
    private func saveButtonAction() -> UIAction {
        let action = UIAction(handler: { _ in
            self.startActivityIndicator()
            self.viewModel.action(.save)
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            }})
        return action
    }
    
    private func configureHierarchy() {
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        [segmentedControl, graphView, measureButton, stopButton]
            .forEach { stackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }
    
    private func configureSegmentedControl() {
        let segments = viewModel.motionDataTypes()
        for (index, item) in segments.enumerated() {
            segmentedControl.insertSegment(
                action: configureSegmentedControlAction(item),
                at: index,
                animated: true
            )
        }
        segmentedControl.selectedSegmentIndex = .zero
    }
    
    private func configureSegmentedControlAction(_ item: String) -> UIAction {
        let action = UIAction(
            title: item,
            handler: { _ in
                self.graphView.resetGraph()
            }
        )
        return action
    }
    
    private func configureButtonActions() {
        measureButton.addAction(measureButtonAction(), for: .touchUpInside)
        stopButton.addAction(stopButtonAction(), for: .touchUpInside)
    }
    
    private func measureButtonAction() -> UIAction {
        return UIAction(handler: { _ in
            self.graphView.resetGraph()
            self.viewModel.action(.start(
                selectedIndex: self.segmentedControl.selectedSegmentIndex,
                handler: self.toggleControlsAvailability)
            )
        })
    }
    
    private func stopButtonAction() -> UIAction {
        return UIAction(handler: { _ in
            self.viewModel.action(.stop(handler: self.toggleControlsAvailability))
        })
    }
    
    private func toggleControlsAvailability() {
        segmentedControl.isEnabled.toggle()
        measureButton.isEnabled.toggle()
        stopButton.isEnabled.toggle()
        navigationItem.rightBarButtonItem?.isEnabled.toggle()
    }
    
    private func showAlert(alertTitle: String) {
        let alertController = UIAlertController(
            title: alertTitle,
            message: .none,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: Constant.Namespace.confirm,
            style: .default
        )
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    private func bind() {
        viewModel.bind(onUpdate: ) { [weak self] coordinate in
            DispatchQueue.main.async {
                self?.graphView.updateGraph(with: coordinate)
            }
        }
        
        viewModel.bind(onError: ) { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                self?.showAlert(alertTitle: errorMessage)
            }
        }
    }

    private func configureActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }

    private func startActivityIndicator() {
        activityIndicator.startAnimating()
    }

    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
