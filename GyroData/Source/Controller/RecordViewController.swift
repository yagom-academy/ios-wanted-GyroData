//
//  RecordViewController.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/26.
//

import UIKit
import CoreMotion

final class RecordViewController: UIViewController {
    
    private var segmentType: TempSensorType = .gyro
    private var recordData: [MeasureData] = []
    
    let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정 시작", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정 중지", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(stopButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let saveCheckButton: UIButton = { //TODO: FileManager Test를 위해 만든 버튼 - 지우면 됨
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("테스트 저장본 소환", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(testButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupButtons()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveNaviButtonDidTap)
        )
        
        MotionManager.shared.setupMotionManagerInterval(at: 0.1)
    }
    
    func setupButtons() {
        view.addSubview(startButton)
        view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 100),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalTo: startButton.widthAnchor),
            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30),
            stopButton.centerXAnchor.constraint(equalTo: startButton.centerXAnchor)
        ])
        
        //TODO: FileManager 테스트를위한 버튼 - 지우기
        view.addSubview(saveCheckButton)
        NSLayoutConstraint.activate([
            saveCheckButton.widthAnchor.constraint(equalTo: startButton.widthAnchor),
            saveCheckButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 30),
            saveCheckButton.centerXAnchor.constraint(equalTo: startButton.centerXAnchor)
        ])
    }
    
    @objc func testButtonDidTap() { // TODO: FileManager 테스트를위한 코드 - 지우기
        FileManager.default.load(path: "test1") { (result: Result<MotionData, Error>) in
            switch result {
            case .success(let motionData):
                print("----")
                print(motionData.measuredData[0])
            case .failure(let error):
                print("Load Error: \(error)")
            }
        }
    }
    
    @objc func startButtonDidTap() {
        startRecording()
    }
    
    @objc func stopButtonDidTap() {
        stopRecording()
    }
    
    @objc func saveNaviButtonDidTap() {
        //TODO: FileManager 작업
        print("Saved \(recordData.count) Measured items")
        let path = "test1"
        let motionData = MotionData(
            path: path,
            measuredData: recordData
        )
        FileManager.default.save(path: path, to: motionData) { (result: Result<Bool, Error>) in
            switch result {
            case .success(_) :
                print("Save Success")
            case .failure(let error) :
                print("error \(error)")
            }
        }
        recordData = []
    }
    
    func startRecording() {
        print("record start")
        MotionManager.shared.startRecording(type: TempSensorType.gyro)
        { [weak self] (measuredData: MeasureData) in
            self?.recordData.append(measuredData)
            print("current time: \(self?.recordData.count ?? -1): \(measuredData)")
            if (self?.recordData.count)! >= 60 { // TODO: 60초 데이터 기준일땐 6000으로 바꾸기
                self?.stopRecording()
            }
        }
    }
    
    func stopRecording() {
        MotionManager.shared.stopRecording(type: segmentType)
        print(recordData[0])
        print("record end : \(recordData.count)")
    }
}
