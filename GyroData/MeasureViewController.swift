//  GyroData - MeasureViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

final class MeasureViewController: UIViewController {
    
    private enum Constant {
        static let leftSegmentedItem = "Acc"
        static let rightSegmentedItem = "Gyro"
        static let measureButtonTitle = "측정"
        static let stopButtonTitle = "정지"
        static let title = "측정하기"
        static let saveButtonTitle = "저장"
    }
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Constant.leftSegmentedItem,
                                                          Constant.rightSegmentedItem])
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: UIControl.State.selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: UIControl.State.normal)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let graphView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let measureButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constant.measureButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Constant.stopButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
    }
    
    private func setupNavigation() {
        navigationItem.title = Constant.title
        navigationController?.navigationBar.topItem?.title = .init()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.saveButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        [measureButton, stopButton].forEach(buttonStackView.addArrangedSubview(_:))
        [segmentedControl, graphView, buttonStackView].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.8),
            
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            graphView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            graphView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 1),

            buttonStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor)
        ])
    }
}
