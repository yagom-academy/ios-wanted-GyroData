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
            static let stackSpacing = CGFloat(8)
        }
    }
    
    private let viewModel: RecordMotionDataViewModel
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constant.Layout.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let segmentedControl = UISegmentedControl()
    private let graphView = GraphView(frame: .zero)
    private let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.Namespace.measure, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.Namespace.stop, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
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
        return UIAction(handler: { _ in
            self.startActivityIndicator()
            DispatchQueue.global().async {
                do {
                    try self.viewModel.throwableAction(.save)
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.showAlert(alertTitle: error.localizedDescription)
                    }
                }
            }
        })
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
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func configureSegmentedControl() {
        let segments = viewModel.motionDataTypes()
        for (index, item) in segments.enumerated() {
            segmentedControl.insertSegment(
                withTitle: item,
                at: index,
                animated: true
            )
        }
        segmentedControl.selectedSegmentIndex = .zero
    }
    
    private func configureButtonActions() {
        measureButton.addAction(measureButtonAction(), for: .touchUpInside)
        stopButton.addAction(stopButtonAction(), for: .touchUpInside)
    }
    
    private func measureButtonAction() -> UIAction {
        return UIAction(handler: { _ in
            self.viewModel.action(.start(
                selectedIndex: self.segmentedControl.selectedSegmentIndex,
                handler: self.toggleButtons)
            )
        })
    }
    
    private func stopButtonAction() -> UIAction {
        return UIAction(handler: { _ in
            self.viewModel.action(.stop(handler: self.toggleButtons))
        })
    }
    
    private func toggleButtons() {
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
        viewModel.bind(onUpdate: ) { coordinate in
            print(coordinate)
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
