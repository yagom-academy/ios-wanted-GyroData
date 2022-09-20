//
//  MeasurmentViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit

class MeasurmentViewController: UIViewController {
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
      let sc = UISegmentedControl(items: ["Acc", "Gyro"])
        sc.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
      return sc
    }()
    
    lazy var accView: UIView = {
      let view = UIView()
      view.backgroundColor = .green
      return view
    }()
    
    lazy var gyroView: UIView = {
      let view = UIView()
      view.backgroundColor = .yellow
      return view
    }()
    
    lazy var measurementButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        button.addTarget(self, action: #selector(measurementPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("정지", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        button.addTarget(self, action: #selector(stopPressed), for: .touchUpInside)
        return button
    }()
    
    var shouldHideFirstView: Bool? {
      didSet {
        guard let shouldHideFirstView = self.shouldHideFirstView else { return }
        self.accView.isHidden = shouldHideFirstView
        self.gyroView.isHidden = !self.accView.isHidden
      }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "측정하기"
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.saveButton
        
        segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
        
        configure()
    }
    
    @objc func saveButtonPressed() {
        // 데이터 저장
    }
    
    @objc func measurementPressed() {
        
    }
    
    @objc func stopPressed() {
        
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
      self.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
    func configure() {
        view.addSubview(segmentedControl)
        view.addSubview(accView)
        view.addSubview(gyroView)
        view.addSubview(measurementButton)
        view.addSubview(stopButton)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        accView.translatesAutoresizingMaskIntoConstraints = false
//        accView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
//        accView.rightAnchor.constraint(equalTo: segmentedControl.rightAnchor).isActive = true
//        accView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
        accView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        accView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        accView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true
        
        gyroView.translatesAutoresizingMaskIntoConstraints = false
//        gyroView.leftAnchor.constraint(equalTo: self.accView.leftAnchor).isActive = true
//        gyroView.rightAnchor.constraint(equalTo: self.accView.rightAnchor).isActive = true
//        gyroView.bottomAnchor.constraint(equalTo: self.accView.bottomAnchor).isActive = true
        gyroView.topAnchor.constraint(equalTo: self.accView.topAnchor).isActive = true
        gyroView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gyroView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        gyroView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true
        
        measurementButton.translatesAutoresizingMaskIntoConstraints = false
        measurementButton.topAnchor.constraint(equalTo: accView.bottomAnchor, constant: 30).isActive = true
        measurementButton.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true

        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.topAnchor.constraint(equalTo: measurementButton.bottomAnchor, constant: 30).isActive = true
        stopButton.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true
        
      }
  }
