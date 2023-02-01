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
        return button
    }()
    
    init() {
        viewModel = RecordMotionDataViewModel(motionDataType: MotionDataType.allCases.map { $0 } [0])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
        title = Constant.Namespace.navigationTitle
        navigationItem.rightBarButtonItem = configureRightBarButton()
    }
    
    private func configureRightBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: Constant.Namespace.rightBarButtonTitle,
            primaryAction: UIAction { [weak self] _ in
                self?.viewModel.action(.save)
            }
        )
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        [segmentedControl, graphView, measureButton, stopButton]
            .forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        configureSegmentedControl()
    }
    
    private func configureSegmentedControl() {
        let segments = viewModel.motionDataTypes()
        for (index, item) in segments.enumerated() {
            segmentedControl.insertSegment(
                action: UIAction(title: item) { _ in
                    self.viewModel.action(.changeSegment(to: index))},
                at: index,
                animated: true
            )
        }
        segmentedControl.selectedSegmentIndex = .zero
    }
}
