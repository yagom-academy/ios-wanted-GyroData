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
        return segmentControl
    }()
    
    private var emptyView: UIView?
    
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
        return button
    }()
    
    private var swiftUIChartsView = GraphView()
    private lazy var hostView = UIHostingController(rootView: swiftUIChartsView)
    private lazy var graphView: UIView = {
        guard let chartView = hostView.view else {
            return UIView(frame: .zero)
        }
        return chartView
    }()
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject private var viewModel = AnalyzeViewModel(
        analysisManager: AnalysisManager(analysis: .accelerate)
    )
    
    private lazy var titleLabelItem: UILabel = {
       let label = UILabel()
        label.text = "측정하기"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()

    private lazy var analyzeButtonItem: UIBarButtonItem = {
       let button = UIBarButtonItem()
        button.title = "저장"
        button.tintColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.input.onViewWillAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = titleLabelItem
        self.navigationItem.rightBarButtonItem = analyzeButtonItem
        self.viewModel.input.onViewDidLoad()
        bind()
        setup()
        setupUI()
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        
        view.addSubviews(
            backgroundView,
            graphView,
            segmentControl,
            analyzeButton,
            stopButton
        )
    }
    
    private func setupUI() {
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
    }
    
    private func bind() {
        viewModel.$analysis
            .sink { [weak self] model in
                guard let self = self else { return }
                self.swiftUIChartsView.dummyData = model
                self.view.setNeedsLayout()
            }
            .store(in: &cancellables)
    }
    
    @objc func tappedAnalyzeButton() {
        viewModel.input.tapAnalyzeButton()
        self.swiftUIChartsView.dummyData = []
        self.view.setNeedsLayout()
    }
}
