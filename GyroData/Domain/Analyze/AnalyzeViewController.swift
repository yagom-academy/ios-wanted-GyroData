//
//  AnalyzeViewController.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import UIKit
import SwiftUI
import Combine

final class AnalyzeViewController: UIViewController {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.center = self.view.center
        indicator.color = UIColor(r: 101, g: 159, b: 247, a: 1)
        return indicator
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(r: 39, g: 40, b: 46, a: 1)
        return view
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Acc", "Gyro"])
        segmentControl.backgroundColor = .systemGray4
        segmentControl.selectedSegmentTintColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(changeSegmentMode), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var analyzeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tappedAnalyzeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tappedStopButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabelItem: UILabel = {
        let label = UILabel()
        label.text = "측정하기"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var saveButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "저장"
        button.tintColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        button.target = self
        button.action = #selector(tappedSaveButton)
        return button
    }()
    
    private lazy var backButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "chevron.backward")
        button.tintColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        button.target = self
        button.action = #selector(tappedBackButton)
        return button
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.text = "X: 0.0"
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.text = "Y: 0.0"
        label.textColor = .green
        label.font = .preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.text = "Z: 0.0"
        label.textColor = .blue
        label.font = .preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return stack
    }()
    
    @ObservedObject private var viewModel = AnalyzeViewModel(analysisManager: AnalysisManager())
    private var cancelable = Set<AnyCancellable>()
    private var swiftUIChartsView = GraphView()
    private lazy var hostView = HostingViewController(model: viewModel.environment)
    private lazy var graphView: UIView = {
        guard let chartView = hostView.view else {
            return UIView(frame: .zero)
        }
        return chartView
    }()
    private var cancelStore: AnyCancellable?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.input.onViewWillAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        bindEvents()
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        self.navigationItem.titleView = titleLabelItem
        self.navigationItem.rightBarButtonItem = saveButtonItem
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        view.addSubviews(
            backgroundView,
            graphView,
            segmentControl,
            analyzeButton,
            stopButton,
            activityIndicator,
            locationStackView
        )
        
        locationStackView.addArrangedSubview(xLabel)
        locationStackView.addArrangedSubview(yLabel)
        locationStackView.addArrangedSubview(zLabel)
    }
    
    private func setupUI() {
        //MARK: - locationStackView
        NSLayoutConstraint.activate([locationStackView.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 10),
                                     locationStackView.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: 5),
                                     locationStackView.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -5),
                                     locationStackView.heightAnchor.constraint(equalToConstant: 50)
                                    ])
        
        
        // MARK: - backgroundView
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 40
        backgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        backgroundView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50)
        ])
        
        // MARK: - segmentControl
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentControl.centerXAnchor.constraint(equalTo: graphView.centerXAnchor),
            segmentControl.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -10),
            segmentControl.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            segmentControl.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
        
        // MARK: - chartView
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            graphView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            graphView.widthAnchor.constraint(equalToConstant: 300),
            graphView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // MARK: - anayzeButton
        analyzeButton.translatesAutoresizingMaskIntoConstraints = false
        analyzeButton.layer.cornerRadius = 100 / 2
        analyzeButton.layer.shadowOpacity = 0.3
        analyzeButton.layer.shadowColor = UIColor(r: 101, g: 159, b: 247, a: 1).cgColor
        analyzeButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        NSLayoutConstraint.activate([
            analyzeButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 80),
            analyzeButton.widthAnchor.constraint(equalToConstant: 100),
            analyzeButton.heightAnchor.constraint(equalToConstant: 100),
            analyzeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100)
        ])
        
        // MARK: - stopButton
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.layer.cornerRadius = 100 / 2
        stopButton.layer.shadowOpacity = 0.3
        stopButton.layer.shadowColor = UIColor(r: 101, g: 159, b: 247, a: 1).cgColor
        stopButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 80),
            stopButton.widthAnchor.constraint(equalToConstant: 100),
            stopButton.heightAnchor.constraint(equalToConstant: 100),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100)
        ])
        
        // MARK: - activityIndicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func bindEvents() {
        viewModel.isLoadingPublisher
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancelable)
        
        viewModel.dismissPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelable)
        
        viewModel.analyzeModelPublisher
            .sink { [weak self] (x: Double, y: Double, z: Double) in
                guard let self = self else { return }
                self.xLabel.text = "X:" + String(format: "%.1f", x)
                self.yLabel.text = "y:" + String(format: "%.1f",y)
                self.zLabel.text = "z:" + String(format: "%.1f",z)
            }
            .store(in: &cancelable)
    }
}

extension AnalyzeViewController {
    
    @objc private func tappedAnalyzeButton() {
        viewModel.input.tapAnalyzeButton()
        segmentControl.isEnabled = false
        saveButtonItem.isEnabled = false
        analyzeButton.isEnabled = false
    }
    
    @objc private func tappedStopButton() {
        viewModel.input.tapStopButton()
        segmentControl.isEnabled = true
        saveButtonItem.isEnabled = true
        analyzeButton.isEnabled = true
    }
    
    @objc private func tappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tappedSaveButton() {
        viewModel.input.tapSaveButton()
    }
    
    @objc private func changeSegmentMode() {
        viewModel.input.changeAnalyzeMode(segmentControl.selectedSegmentIndex)
    }
}
