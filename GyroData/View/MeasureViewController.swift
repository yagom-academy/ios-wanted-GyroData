//
//  MeasureViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit
import CoreMotion

final class MeasureViewController: UIViewController {
    let viewModel = MeasureViewModel()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [MotionType.acc.rawValue, MotionType.gyro.rawValue])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.layer.borderWidth = 1
        control.selectedSegmentTintColor = .systemBlue
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                       for: UIControl.State.normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       for: UIControl.State.selected)
        return control
    }()
    
    private var graphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let measureButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        return activityIndicator
    }()
    
    private let emptyAlert: UIAlertController = {
        var alert = UIAlertController(title: "알림", message: """
                                                            저장할 데이터가 없습니다.
                                                            측정 후 다시 시도해주세요.
                                                            """, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        return alert
    }()
    
    private let failAlert: UIAlertController = {
        var alert = UIAlertController(title: "저장 실패", message: """
                                                                저장이 실패하였습니다.
                                                                다시 시도해주세요.
                                                                """, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureLayout()
        configureAction()
        configureBind()
        configureData()
        
    }
    
    private func configureLayout() {
        view.addSubview(segmentedControl)
        view.addSubview(graphView)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(measureButton)
        buttonStackView.addArrangedSubview(stopButton)
        view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: graphView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: graphView.centerYAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
    }
    
    private func configureAction() {
        self.segmentedControl.addTarget(self,action: #selector(didChangeValue(_:)), for: .valueChanged)
        measureButton.addTarget(self, action: #selector(measureButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureData() {
        viewModel.load()
    }
    
    private func configureBind() {
        viewModel.bindType { index in
            self.segmentedControl.selectedSegmentIndex = index
        }
        
        viewModel.bindStartLoading {
            self.indicatorView.startAnimating()
        }
        
        viewModel.bindStopLoading {
            self.indicatorView.stopAnimating()
        }
        
        viewModel.bindMeasureHandler {
            self.navigationItem.rightBarButtonItem?.isEnabled = $0
            self.segmentedControl.isEnabled = $0
        }
        
        viewModel.bindSaveHandler {
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.bindEmptyHandler {
            self.present(self.emptyAlert, animated: true)
        }
        
        viewModel.bindFailHandler {
            self.present(self.failAlert, animated: true)
        }
        
        viewModel.bindDrawGraphView { coordinate in
            self.graphView.drawLine(x: coordinate.x, y: coordinate.y, z: coordinate.z)
        }
    }
    
    @objc func saveButtonTapped() {
        viewModel.save()
    }
    
    @objc func didChangeValue(_ segment: UISegmentedControl) {
        graphView.configureData()
        viewModel.motionTypeIndex = segment.selectedSegmentIndex
    }
    
    @objc func measureButtonTapped() {
        graphView.configureData()
        viewModel.measure()
    }
    
    @objc func stopButtonTapped() {
        viewModel.stop()
    }
}
