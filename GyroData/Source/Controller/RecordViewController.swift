//
//  RecordViewController.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/26.
//

import UIKit
import CoreMotion

enum GraphViewValue {
    static let samplingCount: Int = 600
}

// 측정시간(start 버튼눌린 첫 시간) Date, 측정타입 String, 측정시간(recordData 개수) Double

protocol RecordViewControllerPopDelegate: AnyObject {
    func saveMeasureData(registTime: Date, type: SensorType, samplingCount: Double)
}

final class RecordViewController: UIViewController {
    
    //MARK: ViewController Properties
    private var isRecorded: Bool = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let isRecorded = self?.isRecorded else { return }
                if isRecorded {
                    self?.segmentedControl.isUserInteractionEnabled = false
                } else {
                    self?.segmentedControl.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    private var isGyroMeasure: Bool? {
        didSet {
            guard let isGyroMeasure = self.isGyroMeasure else { return }
            if isGyroMeasure {
                segmentType = .gyro
            } else {
                segmentType = .acc
            }
        }
    }
    
    weak var recordViewControllerPopProtocol: RecordViewControllerPopDelegate?
    private var recordingStartTime: Date?
    
    private var segmentType: SensorType = .gyro
    private var recordData: [MeasureData] = []
    
    // 그래프 그리기용 변수들
    var currentX: CGFloat = 0
    
    //MARK: View
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let graphView: GraphView = GraphView(frame: .zero, valueCount: GraphViewValue.samplingCount)
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정 시작", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(
            self,
            action: #selector(startButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정 중지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(
            self,
            action: #selector(stopButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: ViewController Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        MotionManager.shared.setupMotionManagerInterval(at: 0.1)
        configureDefaultSetting()
        configureLayout()
        setupRecordTypeSegment()
    }
    
    private func addUIComponents() {
        view.addSubview(segmentedControl)
        view.addSubview(graphView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
    }
    
    private func configureDefaultSetting() {
        view.backgroundColor = .systemBackground
        graphView.setupViewDefault()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveNaviButtonDidTap)
        )
    }
    
    private func configureLayout() {
        addUIComponents()
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 30),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stopButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    
    // segment 동작 코드
    private func setupRecordTypeSegment() {
        self.segmentedControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.didChangeValue(segment: self.segmentedControl)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.isGyroMeasure = segment.selectedSegmentIndex != 0
    }
    
    // 버튼 동작
    @objc private func startButtonDidTap() {
        recordingStartTime = Date()
        if recordData.count == GraphViewValue.samplingCount {
            recordingStartTime = Date()
            currentX = 0
            recordData = [] 
            graphView.setupViewDefault() // 그래프 뷰 초기화
        }
        startRecording()
    }
    
    @objc private func stopButtonDidTap() {
        stopRecording()
    }
    
    @objc private func saveNaviButtonDidTap() {
        guard let startTime = recordingStartTime else {
            return
        }
        
        let dateString = DateFormatterManager.shared.convertToDateString(from: startTime)
        let path = "\(dateString)+\(segmentType.rawValue)"
        
        let motionData = MotionData(
            path: path,
            measuredData: recordData
        )
        
        FileManager.default.save(path: path, to: motionData) { [weak self] (result: Result<Bool, Error>) in
            switch result {
            case .success(_) :
                //pop
                self?.delegateData()
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error) :
                print("error \(error)")
            }
        }
        recordData = []
    }
    
    private func delegateData() {
        guard let recordingStartTime = self.recordingStartTime else {
            return
        }
        
        saveMeasureData(
            registTime: recordingStartTime,
            type: segmentType,
            samplingCount: Double(self.recordData.count / 10) // 데이터 개수 핸드폰으로 테스트
        )
    }
    
    //측정 시작
    /*
     1. 측정값이 비동기로 매니저로부터 넘어옴
     2. recordData에 저장
     3. graphView에 그리기 위한 메서드 호출
     4. 만약 최대 샘플링 개수(시간이 되면) 알아서 멈추도록 지정
     */
    private func startRecording() {
        isRecorded = true
        MotionManager.shared.startRecording(type: segmentType)
        { [weak self] (measuredData: MeasureData) in
            self?.recordData.append(measuredData)
            
            DispatchQueue.main.async {
                // xyz정보가 담긴 구조체와 x 좌표를 위한 현재 몇번째 측정치인지에 대한 count값
                self?.drawMeasurePoint(measureData: measuredData, offset: (self?.recordData.count)!)
            }
            
            if self?.recordData.count ?? 0 >= GraphViewValue.samplingCount {
                self?.stopRecording()
            }
        }
    }
    
    // 측정 중지
    private func stopRecording() {
        if recordData.count == 600 {
            isRecorded = false
        }
        MotionManager.shared.stopRecording(type: segmentType)
    }
    
    private func drawMeasurePoint(measureData: MeasureData, offset: Int) {
        var currentPoint = GraphPoint(0, 0, 0)
        currentPoint.xValue = processLogic(measureData.lotationX)
        currentPoint.yValue = processLogic(measureData.lotationY)
        currentPoint.zValue = processLogic(measureData.lotationZ)
        
        graphView.drawNewData(graphData: currentPoint)
    }
    
    private func processLogic(_ data: Double) -> Double {
        let standardHeight = self.graphView.frame.height / 2
        
        if abs(data) > standardHeight {
            return data * 0.2
        } else {
            return data
        }
    }
}

extension RecordViewController: RecordViewControllerPopDelegate {
    func saveMeasureData(registTime: Date, type: SensorType, samplingCount: Double) {
        self.recordViewControllerPopProtocol?.saveMeasureData(
            registTime: registTime,
            type: type,
            samplingCount: samplingCount
        )
    }
}
