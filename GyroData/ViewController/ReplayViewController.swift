//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreData

class ReplayViewController: UIViewController {
    
    // sample struct
    struct gyroValue {
        let x: Float
        let y: Float
        let z: Float
        
        init(x: Float, y: Float, z: Float) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
    
//    lazy var graphView = UIModule().graphView
    lazy var graphView: UIView = {
        let uiView = UIView()
            uiView.layer.borderColor = UIColor.black.cgColor
            uiView.layer.borderWidth = 2.0
        
        // 그래프 차트의 백그라운드 표현
        self.blockWidth = self.graphViewHeight/8 // 차트 백그라운드의 가로, 세로 칸 수
        let backgroundPath = UIBezierPath()
        for i in [1,2,3,4,5,6,7,8] {
            backgroundPath.move(to: CGPoint(x: Int(blockWidth)*i, y: 0))
            backgroundPath.addLine(to: CGPoint(x: Int(blockWidth)*i, y: 280))
        }
        
        for i in [1,2,3,4,5,6,7,8] {
            backgroundPath.move(to: CGPoint(x: 0, y: Int(blockWidth)*i))
            backgroundPath.addLine(to: CGPoint(x: 280, y: Int(blockWidth)*i))
        }
        
        let chartBackgroundLayer = CAShapeLayer()
        chartBackgroundLayer.frame = uiView.bounds
        chartBackgroundLayer.path = backgroundPath.cgPath
        chartBackgroundLayer.fillColor = UIColor.clear.cgColor
        chartBackgroundLayer.strokeColor = UIColor.gray.cgColor
        chartBackgroundLayer.lineWidth = 1.5
        uiView.layer.addSublayer(chartBackgroundLayer)
        
        return uiView
    }()
    
    /// 빈 블럭
    lazy var invisibleBlock: UILabel = {
        let label = UILabel()
            label.text = " "
        return label
    }()
    
    /// 센서 측정 시작 버튼
    lazy var measureButton: UIButton = {
        let symbolSize = UIImage.SymbolConfiguration(pointSize: 45)
        let button = UIButton(type: .system)
            button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(measurement), for: .touchUpInside)
        return button
    }()
    
    /// 센서 측정 즁지 버튼
    lazy var stopButton: UIButton = {
        let symbolSize = UIImage.SymbolConfiguration(pointSize: 45)
        let button = UIButton(type: .system)
            button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
            button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(stop), for: .touchUpInside)
        return button
    }()
    
    /// 타이머 시간을 표시할 라벨
    lazy var timeLabel: UILabel = {
        let label = UILabel()
            label.text = "0.0"
            label.tintColor = .black
            label.textAlignment = .right
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
            label.text = "View" // "View" or "Play"
            label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            label.tintColor = .black
            label.textAlignment = .left
        return label
    }()
    
    /// 센서 기록을 측정한 시간대
    lazy var timestampLabel: UILabel = {
        let label = UILabel()
            label.text = "2022/09/12 12:33:02"
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.tintColor = .black
            label.textAlignment = .left
        return label
    }()
    
    /// 재생, 정지, 타이머라벨을 위한 스택 뷰
    lazy var playPannelStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.axis = .vertical
        return stackView
    }()
    
    /// 센서 측정 타이머
    lazy var timer = Timer()
    
    // 그래프 뷰의 size
    let graphViewHeight: CGFloat = 280.0
    let graphViewWidth: CGFloat = 280.0
    
    // 1개의 데이터가 차지할 width
    var blockWidth: CGFloat = 0.0
    
    // 그래프 데이터가 저장된 배열
    var graphData = [gyroValue]()
    
    // 임시
    var lineLayer = CAShapeLayer()
    
    // x, y, z선을 추가할 layer
    var xLineLayer = CAShapeLayer()
    var yLineLayer = CAShapeLayer()
    var zLineLayer = CAShapeLayer()
    
    // x, y, z 선
    var xLine = UIBezierPath()
    var yLine = UIBezierPath()
    var zLine = UIBezierPath()
    
    // 데이터를 선택할 인덱스
    var index: Int = 0
    
    // 타이머 실행 상태
    var isRunning: Bool = false
    
    // 타임 라벨에 표시될 시간
    var interval: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: UI Set
        
        self.navigationItem.title = "다시보기"
        self.navigationController?.navigationBar.tintColor = .black
        
        // navibar right menu group
//        let uiBarButtonItemGroup = UIBarButtonItemGroup(barButtonItems: [UIBarButtonItem(title: "다시보기", style: .plain, target: self, action: .none)], representativeItem: .none)
//        self.navigationItem.centerItemGroups = [uiBarButtonItemGroup]
        
        // safeArea
        let safeArea = self.view.safeAreaLayoutGuide
        
        // 헤더 스택 뷰 추가
        self.view.addSubview(headerStackView)
        headerStackView.addArrangedSubview(timestampLabel)
        headerStackView.addArrangedSubview(titleLabel)
        timestampLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor).isActive = true
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        headerStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        headerStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        headerStackView.widthAnchor.constraint(equalToConstant: graphViewWidth).isActive = true
        
        // 그래프 뷰 추가
        self.view.addSubview(graphView)
        
        // 그래프 뷰의 제약조건
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 30).isActive = true
        graphView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: graphViewHeight).isActive = true
        graphView.widthAnchor.constraint(equalToConstant: graphViewWidth).isActive = true

        // 재생, 정지, 타임라벨 표시 패널
        self.view.addSubview(playPannelStackView)
        playPannelStackView.translatesAutoresizingMaskIntoConstraints = false
        playPannelStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20).isActive = true
        playPannelStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        playPannelStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playPannelStackView.widthAnchor.constraint(equalToConstant: graphViewWidth).isActive = true
        playPannelStackView.addArrangedSubview(invisibleBlock)
        playPannelStackView.addArrangedSubview(measureButton)
        playPannelStackView.addArrangedSubview(stopButton)
        playPannelStackView.addArrangedSubview(timeLabel)
        invisibleBlock.widthAnchor.constraint(equalTo: measureButton.widthAnchor).isActive = true
        invisibleBlock.widthAnchor.constraint(equalTo: stopButton.widthAnchor).isActive = true
        invisibleBlock.widthAnchor.constraint(equalTo: timeLabel.widthAnchor).isActive = true
        stopButton.isHidden = !isRunning
        measureButton.isHidden = isRunning
        
        // MARK: 전체 데이터 보여주기
        
        // sample data
//        while graphData.count <= 600 {
//            let x = Float.random(in: -100.0 ..< -70.0)
//            let y = Float.random(in: -20.0 ..< 300.0)
//            let z = Float.random(in: 60.0 ..< 100.0)
//            graphData.append(gyroValue(x: x, y: y, z: z))
//        }
        
        // 임시: 차트데이터 전체 표시
//        self.blockWidth = self.graphViewHeight/600.0
//
//        xLine.move(to: CGPoint(x: 1.5, y: 140))
//        for (i,d) in graphData.enumerated() {
//            let x = CGFloat((i+1)) * blockWidth
//            let y = CGFloat(140.0+d.x)
//            xLine.addLine(to: CGPoint(x: x, y: y))
//        }
//
//        lineLayer.frame = graphView.bounds
//        lineLayer.path = xLine.cgPath
//        lineLayer.fillColor = UIColor.clear.cgColor
//        lineLayer.strokeColor = UIColor.red.cgColor
//        lineLayer.lineWidth = 1.5
//        graphView.layer.addSublayer(lineLayer)
    }
    
    // MARK: 함수
    
    func changeStatus() {
        isRunning = !isRunning
        stopButton.isHidden = !isRunning
        measureButton.isHidden = isRunning
    }
    
    /// 측정을 위한 타이머 실행
    @objc func measurement() {
        // 0.1초마다 측정을위한 타이머 설정
        resetGraph() // 시작 시 초기화
        print("timer scheduling..")
        changeStatus()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGraph), userInfo: nil, repeats: true)
    }
    
    /// 센서 측정 타이머 중지
    @objc func stop() {
        // 중지 시 타이머만 out
        print("timer invalidated")
        timer.invalidate()
        changeStatus()
    }
    
    /// 그래프 업데이트
    @objc func updateGraph() {
        // 모든 데이터를 보여준 뒤 timer out
        if index == 599 { //graphData.count-1
            timer.invalidate()
            return
        }
        
        var value: Float = 100.0
        // 약 30초부터 스케일링 케이스 발생
        if index > 300 {
            value = 300.0
        }
        
        // 0.1초마다 데이터 적재
        let x = Float.random(in: -100.0 ..< -70.0)
        let y = Float.random(in: -20.0 ..< value)
        let z = Float.random(in: 60.0 ..< 100.0)
        graphData.append(gyroValue(x: x, y: y, z: z))
        
        // 타이머 라벨 update
        self.interval += Float(timer.timeInterval)
        self.timeLabel.text = String(format: "%0.1f", arguments: [self.interval])
        
        // 한개의 점이 차지할 width
        self.blockWidth = self.graphViewHeight/600.0
        
        // 각 x, y, z 레이어 add
//        addLayer(xLine, xLineLayer, index, .red)
        addLayer(yLine, yLineLayer, index, .blue)
//        addLayer(zLine, zLineLayer, index, .green)
        // 다음 점 표시를 위한 index 증감
        index += 1
    }
    
    // garphView에 lineLayer를 추가
    func addLayer(_ line: UIBezierPath, _ layer: CAShapeLayer, _ index: Int, _ strokColor: UIColor) {
        // 그래프에서 표현되는 높이값
        var yOffset: Float = 0.0
        switch line {
            case xLine:
                yOffset = graphData[index].x
                break
            case yLine:
                yOffset = graphData[index].y
                break
            case zLine:
                yOffset = graphData[index].z
                break
            default:
                break
        }
        let x = CGFloat((index+1)) * blockWidth
        let y = CGFloat(140.0-yOffset)
        
        if y >= graphViewHeight {
            
        }
        line.addLine(to: CGPoint(x: x, y: y))
            
        layer.frame = graphView.bounds
        layer.path = line.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokColor.cgColor
        layer.lineWidth = 1.5
        graphView.layer.addSublayer(layer)
    }
    
    /// 그래프 초기화
    func resetGraph() {
        print("reset graph")
        index = 0 // index 초기화
        
        // x, y, z 점 위치 초기화
        xLine = UIBezierPath()
        xLine.move(to: CGPoint(x: 1.5, y: 140))
        yLine = UIBezierPath()
        yLine.move(to: CGPoint(x: 1.5, y: 140))
        zLine = UIBezierPath()
        zLine.move(to: CGPoint(x: 1.5, y: 140))
        
        // 각 선 layer graphView로부터 제거
        lineLayer.removeFromSuperlayer()
        xLineLayer.removeFromSuperlayer()
        yLineLayer.removeFromSuperlayer()
        zLineLayer.removeFromSuperlayer()
    }
}
