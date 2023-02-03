//
//  MeasureViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/01/31.
//

import UIKit
import CoreMotion

class MeasureViewController: UIViewController {
    let motionManager = MotionManager()
    
    var motionType: MotionType = .acc
    var coordinates: [Coordinate] = []
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentIndex = 0
        control.layer.borderWidth = 1
        control.selectedSegmentTintColor = .systemBlue
        control.translatesAutoresizingMaskIntoConstraints = false
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                                       for: UIControl.State.normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       for: UIControl.State.selected)
        return control
    }()
    
    var graphView: GraphView = {
        let view = GraphView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let emptyAlert: UIAlertController = {
        var alert = UIAlertController(title: "알림", message: """
                                                            저장할 데이터가 없습니다.
                                                            측정 후 다시 시도해주세요.
                                                            """, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        return alert
    }()
    
    let failAlert: UIAlertController = {
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
    }
    
    func configureNavigationBar() {
        navigationItem.title = "측정하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
    }
    
    func configureAction() {
        self.segmentedControl.addTarget(self,action: #selector(didChangeValue(_:)), for: .valueChanged)
        measureButton.addTarget(self, action: #selector(measureButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    func configureLayout() {
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
    
    @objc func saveButtonTapped() {
        self.indicatorView.startAnimating()
        
        if coordinates.isEmpty {
            self.indicatorView.stopAnimating()
            self.present(self.emptyAlert, animated: true)
            return
        }
        
        FileManager.default.save(path: UUID().uuidString, data: coordinates) { result in
            self.indicatorView.stopAnimating()
            switch result {
            case .success(let path):
                CoreDataManager.shared.create(entity: MotionEntity.self) { entity in
                    entity.id = UUID(uuidString: path)
                    entity.date = Date()
                    entity.time = self.motionManager.second.decimalPlace(1)
                    entity.measureType = self.motionType.rawValue
                }
                self.moveListPage()
            case .failure(_):
                self.present(self.failAlert, animated: true)
            }
        }
    }
    
    @objc func didChangeValue(_ segment: UISegmentedControl) {
        motionType = segment.selectedSegmentIndex == 0 ? .acc : .gyro
    }
    
    @objc func measureButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        segmentedControl.isEnabled = false
        graphView.configureData()
        
        motionManager.configureTimeInterval(interval: 0.1)
        motionManager.start(type: motionType) { data in
            DispatchQueue.main.async {
                self.coordinates.append(data)
                self.graphView.drawLine(x: data.x, y: data.y, z: data.z)
            }
        }
    }
    
    @objc func stopButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        segmentedControl.isEnabled = true
        
        motionManager.stop()
    }
    
    func moveListPage() {
        self.navigationController?.popViewController(animated: true)
    }
}
