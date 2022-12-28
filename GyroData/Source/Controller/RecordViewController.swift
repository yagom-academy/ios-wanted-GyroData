//
//  RecordViewController.swift
//  GyroData
//
//  Created by 유한석 on 2022/12/26.
//

import UIKit
import CoreMotion

enum GraphViewValue {
    static let samplingCount: Int = 60
}

//TODO: 메인 뷰컨에 테이블뷰 셀에 보여질 데이터 딜리게이트로 넘겨야함.
// 측정시간(start 버튼눌린 첫 시간) Date, 측정타입 String, 측정시간(recordData 개수) Double

protocol RecordViewControllerPopDelegate: AnyObject {
    func saveMeasureData(registTime: Date, type: SensorType, samplingCount: Double)
}

final class RecordViewController: UIViewController {
    
    //MARK: ViewController Properties
    var isRecorded: Bool = false {
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
    
    var isGyroMeasure: Bool? {
        didSet {
            guard let isGyroMeasure = self.isGyroMeasure else { return }
            if isGyroMeasure {
                segmentType = .gyro
            } else {
                segmentType = .acc
            }
            print("Segment Changed :\(segmentType)")
        }
    }
    
    weak var recordViewControllerPopProtocol: RecordViewControllerPopDelegate?
    private var recordingStartTime: Date?
    
    private var segmentType: SensorType = .gyro
    private var recordData: [MeasureData] = []
    
    // 그래프 그리기용 변수들
    var currentX: CGFloat = 0
    
    //MARK: View
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let graphView: GraphView = GraphView(frame: .zero, valueCount: GraphViewValue.samplingCount)
    
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
    
    // MARK: ViewController Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveNaviButtonDidTap)
        )
        
        MotionManager.shared.setupMotionManagerInterval(at: 0.1)
        addUIComponents()
        setupLayouts()
        setupRecordTypeSegment()
        graphView.setupViewDefault()
    }
    
    private func addUIComponents() {
        view.addSubview(segmentedControl)
        view.addSubview(graphView)
        view.addSubview(startButton)
        view.addSubview(stopButton)
    }
    
    private func setupLayouts() {
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
    
    @objc func startButtonDidTap() {
        recordingStartTime = Date()
        if recordData.count == GraphViewValue.samplingCount { // 측정완료 되었을 때 또 측정 누르면 그냥 처음부터 되도록
            recordingStartTime = Date()
            currentX = 0
            recordData = [] 
            graphView.setupViewDefault() // 그래프 뷰 초기화
        }
        startRecording()
    }
    
    @objc func stopButtonDidTap() {
        stopRecording()
    }
    
    @objc func saveNaviButtonDidTap() {
        let path = "\(recordingStartTime)+\(segmentType)"
        
        let motionData = MotionData(
            path: path,
            measuredData: recordData
        )
        
        FileManager.default.save(path: path, to: motionData) { [weak self] (result: Result<Bool, Error>) in
            switch result {
            case .success(_) :
                print("Save Success")
                
                guard let recordingStartTime = self?.recordingStartTime,
                      let segmentType = self?.segmentType,
                      let recordCount = self?.recordData.count else {
                    return
                }
                // 본 측정 치의 정보를 delegate로 넘기고
                self?.recordViewControllerPopProtocol?.saveMeasureData(
                    registTime: recordingStartTime, // 측정된 시간
                    type: segmentType, // 측정 타입
                    samplingCount: Double(recordCount) // 얼마나 측정할건지
                )
                //pop
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error) :
                print("error \(error)")
            }
        }
        recordData = []
    }
    
    //측정 시작
    /*
     1. 측정값이 비동기로 매니저로부터 넘어옴
     2. recordData에 저장
     3. graphView에 그리기 위한 메서드 호출
     4. 만약 최대 샘플링 개수(시간이 되면) 알아서 멈추도록 지정
     */
    func startRecording() {
        isRecorded = true
        MotionManager.shared.startRecording(type: segmentType)
        { [weak self] (measuredData: MeasureData) in
            self?.recordData.append(measuredData)
            print(self?.recordData.count)
            DispatchQueue.main.async {
                // xyz정보가 담긴 구조체와 x 좌표를 위한 현재 몇번째 측정치인지에 대한 count값
                self?.drawMeasurePoint(measureData: measuredData, offset: (self?.recordData.count)!)
            }
            
            if self?.recordData.count ?? 0 >= GraphViewValue.samplingCount { // TODO: 60초 데이터 기준일땐 6000으로 바꾸기
                print("??")
                self?.stopRecording()
            }
        }
    }
    
    // 측정 중지
    func stopRecording() {
        if recordData.count == 60 {
            isRecorded = false
        }
        MotionManager.shared.stopRecording(type: segmentType)
    }
    
    func drawMeasurePoint(measureData: MeasureData, offset: Int) {
        var currentPoint = GraphPoint(0, 0, 0)
        currentPoint.xValue = measureData.lotationX
        currentPoint.yValue = measureData.lotationY
        currentPoint.zValue = measureData.lotationZ
        
        graphView.drawNewData(graphData: currentPoint)
    }
}

