//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

final class MeasurementViewController: UIViewController {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [GraphMode.acc.description, GraphMode.gyro.description])
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let graphView: UIView = {
        let graphView = UIView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()

    private let saveButton = UIBarButtonItem()
    private let measurementButton = UIButton()
    private let stopButton = UIButton()
    private let indicatorView = UIActivityIndicatorView(style: .large)

    private let measurementViewModel = MeasurementViewModel()
    private var graphMode = GraphMode.acc

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        configureLayout()
        configureButton()
        configureIndicatorView()
        bind()
    }

    private func configureNavigationBar() {
        saveButton.title = "저장"
        saveButton.target = self
        saveButton.primaryAction = tappedSaveButton()

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = "측정하기"
    }

    private func configureView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(graphView)
        stackView.addArrangedSubview(measurementButton)
        stackView.addArrangedSubview(stopButton)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func configureButton() {
        measurementButton.addAction(tappedMeasurementButton(), for: .touchUpInside)
        stopButton.addAction(tappedStopButton(), for: .touchUpInside)
        segmentedControl.addAction(switchSegmentedControl(), for: .valueChanged)
    }

    private func configureIndicatorView() {
        indicatorView.frame = view.frame
        indicatorView.color = .systemGray
        view.addSubview(indicatorView)
    }

    private func bind() {
        measurementViewModel.isMeasuring.bind { [weak self] isMeasuring in
            guard let isMeasuring = isMeasuring else { return }
            self?.segmentedControl.isEnabled = !isMeasuring
            self?.stopButton.isEnabled = isMeasuring
            self?.saveButton.isEnabled = !isMeasuring
        }

        measurementViewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            // TODO: 얼럿 띄우기
        }

        measurementViewModel.isLoading.bind { [weak self] isLoading in
            guard let isLoading = isLoading else { return }

            if let isLoading = isLoading {
                isLoading ? self?.executeLoadAnimating() : self?.stopLoadAnimating()
            }
        }
    }
}

extension MeasurementViewController {
    private func tappedSaveButton() -> UIAction {
        // TODO: 그래프 뷰에서 데이터 받아오기
        return UIAction { [weak self] _ in
            guard let graphMode = self?.graphMode else { return }
            self?.measurementViewModel.save(graphMode, data: [[Double]])
        }
    }

    private func tappedMeasurementButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let graphMode = self?.graphMode else { return }
            guard let graphView = self?.graphView else { return }
            self?.measurementViewModel.startMeasurement(graphMode, on: graphView)
        }
    }

    private func tappedStopButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let graphMode = self?.graphMode else { return }
            self?.measurementViewModel.stopMeasurement(graphMode)
        }
    }

    private func switchSegmentedControl() -> UIAction {
        return UIAction { [weak self] _ in
            switch self?.segmentedControl.selectedSegmentIndex {
            case GraphMode.acc.option:
                self?.graphMode = .acc
            case GraphMode.gyro.option:
                self?.graphMode = .gyro
            default:
                self?.graphMode = .acc
            }
        }
    }
}

extension MeasurementViewController {
    private func executeLoadAnimating() {
        indicatorView.startAnimating()
    }

    private func stopLoadAnimating() {
        indicatorView.startAnimating()
    }
}
