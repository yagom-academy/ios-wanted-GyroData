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
        viewModel = RecordMotionDataViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        configureButtonActions()
        bind()
    }
    
    private func bind() {
        viewModel.bindOnUpdate { coordinate in
            print(coordinate)
        }
        viewModel.bindOnAdd { motionData in
            print(motionData)
        }
    }
    
    private func setupNavigationBar() {
        title = Constant.Namespace.navigationTitle
        navigationItem.rightBarButtonItem = configureRightBarButton()
    }
    
    private func configureRightBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            title: Constant.Namespace.rightBarButtonTitle,
            primaryAction: rightBarButtonAction()
        )
    }
    
    private func rightBarButtonAction() -> UIAction {
        return UIAction(handler: { _ in
            do {
                try self.viewModel.throwableAction(.save)
            } catch CoreDataError.cannotSaveData {
                self.showAlert(alertTitle: CoreDataError.cannotSaveData.localizedDescription)
            } catch DataStorageError.cannotSaveFile {
                self.showAlert(alertTitle: DataStorageError.cannotSaveFile.localizedDescription)
            } catch {
                return
            }
        })
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
                action: segmentAction(title: item, index: index),
                at: index,
                animated: true
            )
        }
        segmentedControl.selectedSegmentIndex = .zero
    }
    
    private func segmentAction(title: String, index: Int) -> UIAction {
        return UIAction(
            title: title,
            handler: { _ in
                self.viewModel.action(.changeSegment(to: index))
            }
        )
    }
    
    private func showAlert(alertTitle: String) {
        let alertController = UIAlertController(
            title: alertTitle,
            message: .none,
            preferredStyle: .alert)
        present(alertController, animated: true)
    }
}
