//
//  MeasurementViewController.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

final class MeasurementViewController: UIViewController {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 8
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

    private let graphView: GraphView = {
        let graphView = GraphView()
        graphView.layer.borderWidth = 2
        graphView.backgroundColor = .white
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()

    private lazy var saveButton = UIBarButtonItem(title: "저장", primaryAction: tappedSaveButton())

    private let measurementButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

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
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.title = "측정하기"
    }

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(segmentedControl)
        mainStackView.addArrangedSubview(graphView)
        mainStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(measurementButton)
        buttonStackView.addArrangedSubview(stopButton)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: graphView.heightAnchor)
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
        return UIAction { [weak self] _ in
            guard let graphMode = self?.graphMode else { return }
            guard let segmentData = self?.graphView.segmentData else { return }
            self?.measurementViewModel.save(graphMode, data: segmentData)
            self?.navigationController?.popViewController(animated: true)
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
