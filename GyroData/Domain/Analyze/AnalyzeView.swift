//
//  AnalyzeView.swift
//  GyroData
//
//  Created by Ellen J on 2022/12/28.
//

import UIKit
import SwiftUI

final class AnalyzeView: UIView {
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
    
    private lazy var graphView: UIView = {
        return setupHostView()
    }()
    
    private lazy var analyzeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 101, g: 159, b: 247, a: 1)
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHostView() -> UIView {
        let host = UIHostingController(rootView: GraphView())
        guard let chartView = host.view else { return UIView(frame: .zero) }
        return chartView
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        addSubviews(
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
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
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
            graphView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            graphView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
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
            analyzeButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -100)
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
            stopButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 100)
        ])
    }
}
