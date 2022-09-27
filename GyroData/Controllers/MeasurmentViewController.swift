//
//  MeasurmentViewController.swift
//  GyroData
//
//  Created by KangMingyo on 2022/09/20.
//  Modefied by yh on 2022/09/26

import UIKit
import CoreMotion

class MeasurmentViewController: UIViewController {

    let graphViewMaker = GraphViewMaker.shared
    let motionManager = MotionManager.shared
    
    // 데이터
    private var xData = [Float]()
    private var yData = [Float]()
    private var zData = [Float]()
    
    // 모션 값 타입 Gyro or Accelerometer
    var name: MotionManager.MotionType = .acc
    
    // 최종 측정 시간
    var time: String = ""
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
      let sc = UISegmentedControl(items: ["Acc", "Gyro"])
        sc.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
      return sc
    }()
    
    lazy var backgroundView = graphViewMaker.backgroundView
    lazy var graphView = graphViewMaker.graphView
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.gray
        return activityIndicator
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager.delegate = self
        
        title = "측정하기"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = saveButton
        let backButtonAction = UIAction(handler: { action in
            if self.motionManager.isRunning {
                let alert = UIAlertController(title: "데이터 측정 중입니다.", message: "종료 시 측정기록은 사라집니다.", preferredStyle: UIAlertController.Style.alert)
                let quit = UIAlertAction(title: "종료", style: .destructive, handler: { action in
                    self.motionManager.cancel()
                    self.navigationController?.popViewController(animated: true)
                })
                let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
                alert.addAction(quit)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.motionManager.cancel()
                self.navigationController?.popViewController(animated: true)
            }
        })
        navigationItem.backAction = backButtonAction
        
        segmentedControl.selectedSegmentIndex = 0
        didChangeValue(segment: segmentedControl)
        
        configure()
    }

    /// 측정을 위한 타이머 실행 
    @objc func measurementPressed() {
        graphViewMaker.graphViewWidth = graphView.bounds.width - 10
        if motionManager.isRunning {
            let alert = UIAlertController(title: "이미 측정 중입니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        else {
            motionManager.start(type: name, interval: 0.1)
        }
    }
    
    @objc func saveButtonPressed() {
        
        //activityIndicator 시작
        activityIndicator.startAnimating()
        
        if motionManager.isRunning {
            // 측정 중
            let alert = UIAlertController(title: "측정 중 데이터 저장불가", message: "확인을 눌러주세요.", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            // 측정 시작 전
            if time == "0.0" {
                let alert = UIAlertController(title: "측정을 시작하세요", message: "확인을 눌러주세요.", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
            } else {
                if xData.count == 0 || yData.count == 0 || zData.count == 0 {
                    let alert = UIAlertController(title: "데이터가 존재하지 않습니다.", message: "확인을 눌러주세요.", preferredStyle: UIAlertController.Style.alert)
                    let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(cancel)
                    present(alert, animated: true, completion: nil)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        do {
                            try DataManager.shared.addNewSave(self.name.rawValue, Float(self.time)!, self.xData, yData: self.yData, zData: self.zData)
                            self.navigationController?.popViewController(animated: true)
                        } catch let error as NSError {
                            let alert = UIAlertController(title: "저장 실패", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
                            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.xData.removeAll(keepingCapacity: false)
                        self.yData.removeAll(keepingCapacity: false)
                        self.zData.removeAll(keepingCapacity: false)
                        self.time = "0.0"
                        
                        //activityIndicator 중지
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    @objc func stopPressed() {
        if motionManager.isRunning {
            motionManager.cancel()
        }
        else {
            let alert = UIAlertController(title: "실행 상태가 아닙니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        if motionManager.isRunning {
            let alert = UIAlertController(title: "측정중에는 타입을 변경불가", message: "확인을 눌러주새요.", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            segment.selectedSegmentIndex = name == .gyro ? 1 : 0
        } else {
            let type = MotionManager.MotionType.self
            name = segment.selectedSegmentIndex == 1 ? type.gyro : type.acc
        }
    }
    
    func configure() {
        view.addSubview(segmentedControl)
        view.addSubview(measurementButton)
        view.addSubview(stopButton)
        view.addSubview(backgroundView)
        view.addSubview(activityIndicator)
        
        backgroundView.addSubview(graphView)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: graphViewMaker.graphViewHeight).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor).isActive = true
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5).isActive = true
        graphView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5).isActive = true
        graphView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5).isActive = true
        graphView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5).isActive = true
        
        measurementButton.translatesAutoresizingMaskIntoConstraints = false
        measurementButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 30).isActive = true
        measurementButton.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true

        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.topAnchor.constraint(equalTo: measurementButton.bottomAnchor, constant: 30).isActive = true
        stopButton.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor).isActive = true
        
        // 좌표값 display
        self.view.addSubview(graphViewMaker.OffsetPannelStackView)
        graphViewMaker.OffsetPannelStackView.translatesAutoresizingMaskIntoConstraints = false
        graphViewMaker.OffsetPannelStackView.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: 60).isActive = true
        graphViewMaker.OffsetPannelStackView.centerXAnchor.constraint(equalTo: segmentedControl.centerXAnchor).isActive = true
        graphViewMaker.OffsetPannelStackView.widthAnchor.constraint(equalToConstant: graphViewMaker.graphViewWidth - 20).isActive = true
    }
    
    deinit {
        print("deinit")
    }
}

//MARK: Extension

extension MeasurmentViewController: MotionManagerDelegate {
    func motionValueDidUpdate(data: MotionManager.MotionValue, interval: TimeInterval) {
        graphViewMaker.draw(data: data, interval: interval)
        xData.append(Float(data.x))
        yData.append(Float(data.y))
        zData.append(Float(data.z))
    }
    
    func motionValueUpdateDidEnd(interval: TimeInterval) {
        print("motionValueUpdateDidEnd")
        self.time = String(format: "%0.1f", interval)
    }
    
    func motionValueUpdateWillStart() -> Bool {
        return graphViewMaker.measurement()
    }
    
    func motionValueUpdateWillEnd() -> Bool {
        return graphViewMaker.stopMeasurement()
    }
}
