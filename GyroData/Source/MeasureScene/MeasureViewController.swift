//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 이태영 on 2023/02/02.
//

import UIKit

final class MeasureViewController: UIViewController {
    private let measureViewModel: MeasureViewModel
    
    private let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemGray2, for: .disabled)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Acc", "Gyro"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .systemBlue
        return segmentControl
    }()
    
    private let graphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(measureViewModel: MeasureViewModel) {
        self.measureViewModel = measureViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubview()
        configureLayout()
        configureNavigation()
        configureSubviewsAction()
        bindToMeasureViewModel()
    }
    
    private func bindToMeasureViewModel() {
        measureViewModel.bindCanChangeMotionType { [weak self] canChange in
            self?.segmentControl.isUserInteractionEnabled = canChange
        }
        
        measureViewModel.bindCanStopMeasure { [weak self] canStop in
            self?.stopButton.isEnabled = canStop
        }
        
        measureViewModel.bindCanSaveMeasureData { [weak self] canSave in
            self?.navigationItem.rightBarButtonItem?.isEnabled = canSave
        }
        
        measureViewModel.bindAlertMessage { [weak self] message in
            self?.indicator.stopAnimating()
            let alert = UIAlertController(
                title: nil,
                message: message,
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                self?.dismiss(animated: true)
            }
            alert.addAction(okAction)
            self?.present(alert, animated: true)
        }
    }
}

// MARK: Action Method
extension MeasureViewController {
    @objc private func tapMeasureButton() {
        measureViewModel.action(.measure)
    }
    
    @objc private func tapStopButton() {
        measureViewModel.action(.stop)
    }
    
    @objc private func tapSaveButton() {
        indicator.startAnimating()
        measureViewModel.action(.save(handler: { [weak self] in
            self?.indicator.stopAnimating()
            self?.navigationController?.popViewController(animated: true)
        }))
    }
    
    @objc private func tapSegmentControl(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedTitle = sender.titleForSegment(at: selectedIndex)
        measureViewModel.action(.motionTypeChange(with: selectedTitle))
    }
}

// MARK: UI Configuration
extension MeasureViewController {
    private func configureSubview() {
        [measureButton, stopButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [segmentControl, graphView].forEach {
            graphStackView.addArrangedSubview($0)
        }
        
        [graphStackView, buttonStackView].forEach {
            totalStackView.addArrangedSubview($0)
        }
        
        view.backgroundColor = .systemBackground
        view.addSubview(totalStackView)
        view.addSubview(indicator)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            totalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            totalStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor),
            
            graphStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4),
            
            indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    private func configureNavigation() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(tapSaveButton))
    }
    
    private func configureSubviewsAction() {
        measureButton.addTarget(self, action: #selector(tapMeasureButton), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(tapStopButton), for: .touchUpInside)
        segmentControl.addTarget(self, action: #selector(tapSegmentControl), for: .valueChanged)
    }
}

