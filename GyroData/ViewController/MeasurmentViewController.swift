//
//  MeasurmentViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreMotion

class MeasurmentViewController: UIViewController {

    let graphViewMaker = GraphViewMaker.shared
    
    var time: Float = 0.0
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
      let sc = UISegmentedControl(items: ["Acc", "Gyro"])
        sc.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
      return sc
    }()
    
    lazy var accView = graphViewMaker.accView
    lazy var gyroView = graphViewMaker.gyroView
    
    /// acc graphView
    lazy var graphView = graphViewMaker.graphView
    
    /// gyro graphView
    lazy var gyroGraphView = graphViewMaker.gyroGraphView
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        graphViewMaker.stopMeasurement()
        graphViewMaker.resetGraph()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphViewMaker.delegate = self
        
        title = "측정하기"
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.saveButton
        
        segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
        
        configure()
    }

    /// 측정을 위한 타이머 실행
    @objc func measurementPressed() {
        graphViewMaker.measurement()
    }
    
    @objc func saveButtonPressed() {
        if graphViewMaker.isRunning {
            let alert = UIAlertController(title: "측정 중 데이터 저장불가", message: "확인을 눌러주새요.", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        } else {
//            print(xData)
//            print(yData)
//            print(zData)
            print(time)
        }
    }
    
    @objc func stopPressed() {
        graphViewMaker.stopMeasurement()
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        if graphViewMaker.isRunning {
            //Alert창 띄워보자
            if accView.isHidden == true {
                segment.selectedSegmentIndex = 1
            } else {
                segment.selectedSegmentIndex = 0
            }
            let alert = UIAlertController(title: "측정중에는 타입을 변경불가", message: "확인을 눌러주새요.", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            self.shouldHideFirstView = segment.selectedSegmentIndex != 0
        }
    }
    
    func configure() {
        view.addSubview(segmentedControl)
        view.addSubview(accView)
        view.addSubview(gyroView)
        view.addSubview(measurementButton)
        view.addSubview(stopButton)
        
        accView.addSubview(graphView)
        gyroView.addSubview(gyroGraphView)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        accView.translatesAutoresizingMaskIntoConstraints = false
        accView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        accView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        accView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true
        
        gyroView.translatesAutoresizingMaskIntoConstraints = false
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
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: accView.topAnchor, constant: 5).isActive = true
        graphView.leadingAnchor.constraint(equalTo: accView.leadingAnchor, constant: 5).isActive = true
        graphView.trailingAnchor.constraint(equalTo: accView.trailingAnchor, constant: -5).isActive = true
        graphView.bottomAnchor.constraint(equalTo: accView.bottomAnchor, constant: -5).isActive = true
        
        gyroGraphView.translatesAutoresizingMaskIntoConstraints = false
        gyroGraphView.topAnchor.constraint(equalTo: gyroView.topAnchor, constant: 5).isActive = true
        gyroGraphView.leadingAnchor.constraint(equalTo: gyroView.leadingAnchor, constant: 5).isActive = true
        gyroGraphView.trailingAnchor.constraint(equalTo: gyroView.trailingAnchor, constant: -5).isActive = true
        gyroGraphView.bottomAnchor.constraint(equalTo: gyroView.bottomAnchor, constant: -5).isActive = true
        
      }
  }

extension MeasurmentViewController: GraphViewMakerDelegate {
    func graphViewDidEnd() {
        // timer is invalidated
        print("graphViewDidEnd")
//        changeStatus()
    }
    
    func graphViewDidPlay() {
        // timer is fire
        print("graphViewDidPlay")
//        changeStatus()
    }
    
    func graphViewDidUpdate(interval: Float, x: Float, y: Float, z: Float) {
//        print("interval: \(interval)")
//        print("x: \(x) y: \(y) z: \(z)")
//        timeLabel.text = String(format: "%0.1f", arguments: [interval])
        time = interval
        print(String(format: "%0.1f", arguments: [time]))
    }
}
