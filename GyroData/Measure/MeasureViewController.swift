//
//  MeasureViewController.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import UIKit
import CoreMotion

enum sensorType: Int {
    case acceleration = 0
    case gyroscope = 1
}

struct MotionData: Codable {
    let coodinate: coodinateData
}
struct coodinateData: Codable {
    let x: Double
    let y: Double
    let z: Double
}

class MeasureViewController: UIViewController {
    
    let mainView = MeasureView()
    weak var timer: Timer?
    var graphView: GraphView!
    let stepDuration = 0.1
    var aData: CGFloat = 0.0
    var bData: CGFloat = 0.0
    var cData: CGFloat = 0.0
    var aBuffer = GraphBuffer(count: 100)
    var bBuffer = GraphBuffer(count: 100)
    var cBuffer = GraphBuffer(count: 100)
    var countDown: Double = 0.0
    var graphFlag = 0
    var saveMotionData: [MotionData] = []
    
    override func loadView() {
        self.view = mainView
        self.navigationItem.title = "측정하기"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        graphView = mainView.lineChartView as? GraphView
        graphView.aPoint = aBuffer
        graphView.bPoint = bBuffer
        graphView.cPoint = cBuffer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        mainView.segmentControl.selectedSegmentIndex = 0
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.rightBarButtonItem?.isEnabled = false
        mainView.measureButton.addTarget(self, action: #selector(measureButtonClicked), for: .touchUpInside)
        mainView.stopButton.addTarget(self, action: #selector(stopButtonClicked), for: .touchUpInside)
        mainView.segmentControl.addTarget(self, action: #selector(segmentFlag), for: .valueChanged)
    }
    
    // MARK: incomplete
    @objc func saveButtonClicked() {
        self.navigationController?.popViewController(animated: true)
        saveMeasureDataAsJSON()
    }
    
    @objc func segmentFlag(_ sender: UISegmentedControl) {
        graphFlag = sender.selectedSegmentIndex
    }
    
    @objc func measureButtonClicked() {
        
        print("측정")
        graphView.maxValue = 1
        graphView.minValue = -1
        mainView.stopButton.isEnabled = true
        mainView.measureButton.isEnabled = false
        mainView.segmentControl.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        countDown = 600 //max 60초
        saveMotionData = []
        
        if graphFlag == 0 {
            MotionManager.shared.startAccelerometerUpdates()
            
        } else {
            MotionManager.shared.startGyroUpdates()
        }
        //기존 값이 있다면 초기화
        self.graphView.reset()
        timer = Timer.scheduledTimer(withTimeInterval: stepDuration
                                     , repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            var motionData: [CGFloat]
            
            //segmentControl value를 읽어 가속도/자이로 중 하나의 MotionManager 실행
            if self.graphFlag == 0 {
                guard let data = MotionManager.shared.accelerometerData?.acceleration else { return }
                motionData = [data.x, data.y, data.z]
            } else {
                guard let data = MotionManager.shared.gyroData?.rotationRate else { return }
                motionData = [data.x, data.y, data.z]
            }
            //데이터를 배열에 저장해둔다
            self.saveMotionData.append(MotionData(coodinate: coodinateData(x: motionData[0], y: motionData[1], z: motionData[2])))
            //받아온 데이터로 그래프 그리기, 카운트다운 60초
            self.graphView.animateNewValue(aValue: motionData[0], bValue: motionData[1], cValue: motionData[2], duration: self.stepDuration)
            self.countDown -= 1
            if self.countDown <= 0 {
                self.stopMeasure()
            }
        }
        
    }
    
    func saveMeasureDataAsJSON() {
        
        let manager = CoreDataManager.shared
        let coverData = Measure(title: "\(sensorType(rawValue: graphFlag)!)", second: (600.0 - self.countDown)/10)
        
        //json 형식으로 인코딩 후, 파일 저장 파일명은 코어데이터의 UUID값
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.saveMotionData)
            if let jsonString = String(data: data, encoding: .utf8) {
                let result = MeasureFileManager.shared.saveFile(jsonString, coverData)
                if !result {
                    print("저장 실패 File Manager Error")
                    return
                } else {
                    let result = manager.insertMeasure(measure: coverData)
                    if !result {
                        print("저장 실패 Core Data error")
                        return
                    }
                }
                navigationItem.rightBarButtonItem?.isEnabled = false
                //저장 후 배열 및 그래프 초기화
                saveMotionData = []
                self.graphView.reset()
            }
        } catch {
            print(error)
        }
    }
    
    func stopMeasure() {
        timer?.invalidate()
        mainView.stopButton.isEnabled = false
        mainView.measureButton.isEnabled = true
        mainView.segmentControl.isEnabled = true
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func stopButtonClicked() {
        stopMeasure()
    }
    
    
}
