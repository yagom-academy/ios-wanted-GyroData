//
//  GraphViewMaker.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/22.
//

import UIKit
import CoreMotion

protocol GraphViewMakerDelegate {
    /// 그래프가 업데이트 될때 호출됨.
    func graphViewDidUpdate(interval: String, x: Float, y: Float, z: Float)
    /// graphView의 에니메이션을 수행하는 타이머가 중지될때 호출되어짐.
    func graphViewDidEnd()
    /// graphView의 에니메이션을 수행하는 타이머가 시작될때 호출되어짐.
    func graphViewDidPlay()
}

/**
    그래프뷰 모듈
 
    그래프 제공 및 애니메이션 시작, 중단, 리셋기능 존재
 */
class GraphViewMaker {
    
    /// 그래프의 선을 표현하는 방식
    enum addLayerOption {
        /// 리플레이를 한번에 보여주기.
        case replayonce
        /// 리플레이를 애니메이션으로 보여주기.
        case replay
        /// 실시간 측정시 애니메이션으로 보여주기.
        case measurement
    }
    
    let customGreen: UIColor = UIColor(red: 0.3608, green: 0.8196, blue: 0.3804, alpha: 1.0)
    
    static let shared = GraphViewMaker()
    public var delegate: GraphViewMakerDelegate!
    
    private init() {
    }
    
    /// Acc, gyro manager
    private let manager = CMMotionManager()
    
    /// 그래프 뷰의 Height
    public let graphViewHeight: CGFloat = 300.0
    
    /// 그래프 뷰의 Width
    public var graphViewWidth: CGFloat = 300.0
    
    /// 1개의 데이터가 차지할 width
    private var blockWidth: CGFloat = 0.0

    /// 그래프 기준점
    private var graphBaseHeight: CGFloat = 0.0
    
    /// 센서 측정 타이머
    lazy private var timer = Timer()
    lazy private var accTimer = Timer()
    lazy private var timeoutTimer = Timer()

    // 데이터
    private var xData = [Float]()
    private var yData = [Float]()
    private var zData = [Float]()
    private var graphData = [sensorValue]()
    
    public var data: Save?

    // x, y, z선을 추가할 layer
    private var xLineLayer = CAShapeLayer()
    private var yLineLayer = CAShapeLayer()
    private var zLineLayer = CAShapeLayer()

    // x, y, z 선
    private var xLine = UIBezierPath()
    private var yLine = UIBezierPath()
    private var zLine = UIBezierPath()

    // 데이터를 선택할 인덱스
    private var index: Int = 0
    
    ///
    private var maxIndex: Int = 600
    
    /// 현재 측정 시간 or 재생 시간
    private var interval: Float = 0.0
    
    /// 총 측정 시간
    private var time: Float = 0.0
    
    /// deprecated
    private var timeLeft = 600.0
    
    private var name: String = "Accelerometer"
    
    /// 그래프 뷰 애니메이션을 담당하는 타이머의 상태
    public var isRunning: Bool = false
    
    /// 그래프 스케일링 시 적용될 변수 값
    private var multiplier: Float = 1.0
    
    /// 현재 x, y, z 좌표값의 절대값 최대치를 담는 변수
    private var maxOffset: Float = 0.0
    
    lazy public var accView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy public var gyroView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      return view
    }()
    
    lazy public var replayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    /// 그래프 뷰를 불러옵니다.
    lazy public var accGraphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy public var gyroGraphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy public var replayGraphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .white
        return view
    }()
    
    public struct sensorValue {
        let x: Float
        let y: Float
        let z: Float
        
        init(x: Float, y: Float, z: Float) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
    
    /// 센서 x 값
    lazy private var xOffsetLabel: UILabel = {
        let label = CommonUIModule().creatLabel(text: "x: 0", color: .red, alignment: .left, fontSize: 13, fontWeight: .regular)
        return label
    }()
    
    /// 센서 y값
    lazy private var yOffsetLabel: UILabel = {
        let label = CommonUIModule().creatLabel(text: "y: 0", color: customGreen, alignment: .center, fontSize: 13, fontWeight: .regular)
        return label
    }()
    
    /// 센서 z값
    lazy private var zOffsetLabel: UILabel = {
        let label = CommonUIModule().creatLabel(text: "z: 0", color: .blue, alignment: .right, fontSize: 13, fontWeight: .regular)
        return label
    }()
    
    /// x, y, z 좌표값 표시 뷰
    lazy public var OffsetPannelStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.backgroundColor = UIColor(white: 0.98, alpha: 0.8)
            stackView.layer.masksToBounds = true
            stackView.layer.cornerRadius = 8
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
            stackView.addArrangedSubview(xOffsetLabel)
            stackView.addArrangedSubview(yOffsetLabel)
            stackView.addArrangedSubview(zOffsetLabel)
            xOffsetLabel.widthAnchor.constraint(equalTo: yOffsetLabel.widthAnchor).isActive = true
            xOffsetLabel.widthAnchor.constraint(equalTo: zOffsetLabel.widthAnchor).isActive = true
        return stackView
    }()
    
    /**
        센서 정보 수집 및 그래프뷰 그리기를 시작합니다.  (측정용)
     */
    public func measurement() {
        // 센서 정보 수집 시작
        manager.startGyroUpdates()
        manager.startAccelerometerUpdates()
        
        //업데이트 간격
        manager.accelerometerUpdateInterval = 0.1
        manager.gyroUpdateInterval = 0.1
        
        // 0.1초마다 측정을위한 타이머 설정
        resetGraph() // 시작 시 초기화
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGraphForMeasurement), userInfo: nil, repeats: true)
        isRunning = true
        delegate.graphViewDidPlay()
    }
    
    /**
        그래프에 데이터 배열을 0.1초 단위로 그려줍니다.
     */
    public func play(animated: Bool) {
        resetGraph()
        xData = data?.xData as! [Float]
        yData = data?.yData as! [Float]
        zData = data?.zData as! [Float]
        if !animated {
            showGraph()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGraphForPlay), userInfo: nil, repeats: true)
            isRunning = true
        }
        delegate.graphViewDidPlay()
    }
    
    /**
        그래프 데이터를 한번에 보여줌.
     */
    public func showGraph() {
        
        while index < xData.count {
            let x = xData[index]
            let y = yData[index]
            let z = zData[index]
            graphData.append(sensorValue(x: x, y: y, z: z))
            compareMaxValue(x, y, z)
            index += 1
        }
        
        xOffsetLabel.text = "x: \(String(format: "%0.f", xData[xData.count-1]))"
        yOffsetLabel.text = "y: \(String(format: "%0.f", yData[yData.count-1]))"
        zOffsetLabel.text = "z: \(String(format: "%0.f", zData[zData.count-1]))"
        
        // 한개의 점이 차지할 width
        blockWidth = graphViewWidth / CGFloat(maxIndex)
        
        xLine = UIBezierPath()
        xLine.move(to: CGPoint(x: 5, y: Double(graphBaseHeight)))
        yLine = UIBezierPath()
        yLine.move(to: CGPoint(x: 5, y: Double(graphBaseHeight)))
        zLine = UIBezierPath()
        zLine.move(to: CGPoint(x: 5, y: Double(graphBaseHeight)))
        
        // 각 x, y, z 레이어 add
        addLayer(xLine, xLineLayer, .red, .replayonce)
        addLayer(yLine, yLineLayer, customGreen, .replayonce)
        addLayer(zLine, zLineLayer, .blue, .replayonce)
    }
    
    /**
        센서 측정 중단
     */
    @objc func stopMeasurement() {
        if isRunning {
            time = interval
            timer.invalidate()
            accTimer.invalidate()
            isRunning = false
            delegate.graphViewDidEnd()
            manager.stopGyroUpdates()
            manager.stopAccelerometerUpdates()
            resetGraph()
        } else {
            print("실행 상태가 아닙니다.")
        }
    }
    
    /**
        그래프 애니메이션을 중단합니다. timer invalidate
     */
    @objc public func stop() {
        timer.invalidate()
        isRunning = false
        delegate.graphViewDidEnd()
    }
    
    /**
        센서 측정시 사용될 그래프 업데이트 함수  (측정용)
     */
    @objc private func updateGraphForMeasurement() {
        
        // 측정 종료 시점
        if index == maxIndex {
            print(index)
            stopMeasurement()
            return
        }
        
        if self.accView.isHidden == false {
            if let accData = self.manager.accelerometerData {
                let x: Float = Float(accData.acceleration.x)
                let y: Float = Float(accData.acceleration.y)
                let z: Float = Float(accData.acceleration.z)
                self.xData.append(x)
                self.yData.append(y)
                self.zData.append(z)
                print("x: \(x), y: \(y), z: \(z)")
                graphData.append(sensorValue(x: x, y: y, z: z))
                self.name = "Accelerometer"
                self.interval += timer.timeInterval.fixed(2)
                updateOffsetDisplay(interval, x, y , z)
                compareMaxValue(x, y, z)
            }
        } else {
            if let gyrodata = self.manager.gyroData {
                let x: Float = Float(gyrodata.rotationRate.x)
                let y: Float = Float(gyrodata.rotationRate.y)
                let z: Float = Float(gyrodata.rotationRate.z)
                self.xData.append(x)
                self.yData.append(y)
                self.zData.append(z)
                graphData.append(sensorValue(x: x, y: y, z: z))
                print("x: \(x), y: \(y), z: \(z)")
                self.name = "Gyro"
                self.interval += timer.timeInterval.fixed(2)
                updateOffsetDisplay(interval, x, y , z)
                compareMaxValue(x, y, z)
            }
        }
        
        // 한개의 점이 차지할 width
        self.blockWidth = self.graphViewWidth / CGFloat(maxIndex)
        
        // 각 x, y, z 레이어 add
        addLayer(xLine, xLineLayer, .red, .measurement)
        addLayer(yLine, yLineLayer, customGreen, .measurement)
        addLayer(zLine, zLineLayer, .blue, .measurement)
        
        // 다음 점 표시를 위한 index 증감
        index += 1
    }
    
    func compareMaxValue(_ x: Float, _ y: Float, _ z: Float) {
        // x, y, z 절대값으로 비교 및 최대값 대체
        let max = [x, y, z].sorted { abs($0) > abs($1) }.first!
        maxOffset = abs(max) > maxOffset ?
            abs(max) : maxOffset
    }
    
    func updateOffsetDisplay(_ interval: Float, _ x: Float, _ y: Float, _ z: Float) {
        delegate.graphViewDidUpdate(interval: String(format: "%0.1f", interval), x: Float(x), y: Float(y), z: Float(z))
        xOffsetLabel.text = "x: \(String(format: "%0.f", x))"
        yOffsetLabel.text = "y: \(String(format: "%0.f", y))"
        zOffsetLabel.text = "z: \(String(format: "%0.f", z))"
    }
    
    /**
        그래프 Replay 시 호출되는 함수
     */
    @objc private func updateGraphForPlay() {
        
        // 측정 종료 시점
        if index == xData.count {
            stop()
            return
        }
        
        let x = xData[index]
        let y = yData[index]
        let z = zData[index]
        graphData.append(sensorValue(x: x, y: y, z: z))
        compareMaxValue(x, y, z)
        
        // 타이머 라벨 update
        self.interval += timer.timeInterval.fixed(2)
        updateOffsetDisplay(interval, x, y, z)
        
        // 한개의 점이 차지할 width
        blockWidth = graphViewWidth / CGFloat(maxIndex)
        
        // 각 x, y, z 레이어 add
        addLayer(xLine, xLineLayer, .red, .replay)
        addLayer(yLine, yLineLayer, customGreen, .replay)
        addLayer(zLine, zLineLayer, .blue, .replay)
        
        // 다음 점 표시를 위한 index 증감
        index += 1
    }
    
    /**
        graphView 위에 선을 그려주는 함수
     */
    private func addLayer(_ line: UIBezierPath, _ layer: CAShapeLayer, _ strokColor: UIColor, _ option: addLayerOption = .measurement) {
        
        // 최대값에 따른 스케일링 비율 설정
        let baseHeight: Float = Float(graphBaseHeight)
        if (maxOffset >= baseHeight) || (maxOffset <= -baseHeight) {
            // 기준점은 높이의 절반 값
            // 값이 baseHeight값의 절대값보다 크게되면 그래프 최대치를 초과하는것.
            multiplier = ((baseHeight / maxOffset) - 0.05)
        }
        
        // x, y, z 라인 구분
        switch line {
            case xLine:
                if option != .replayonce {
                    xLine = UIBezierPath()
                    xLine.move(to: CGPoint(x: 5, y: Double(baseHeight)))
                }
                for (i, data) in graphData.enumerated() {
                    let x = CGFloat((i+1)) * blockWidth + 5
                    let y = CGFloat(baseHeight - (data.x * multiplier))
                    xLine.addLine(to: CGPoint(x: x, y: y))
                }
                break
            case yLine:
                if option != .replayonce {
                    yLine = UIBezierPath()
                    yLine.move(to: CGPoint(x: 5, y: Double(baseHeight)))
                }
                for (i, data) in graphData.enumerated() {
                    let x = CGFloat((i+1)) * blockWidth + 5
                    let y = CGFloat(baseHeight - (data.y * multiplier))
                    yLine.addLine(to: CGPoint(x: x, y: y))
                }
                break
            case zLine:
                if option != .replayonce {
                    zLine = UIBezierPath()
                    zLine.move(to: CGPoint(x: 5, y: Double(baseHeight)))
                }
                for (i, data) in graphData.enumerated() {
                    let x = CGFloat((i+1)) * blockWidth + 5
                    let y = CGFloat(baseHeight - (data.z * multiplier))
                    zLine.addLine(to: CGPoint(x: x, y: y))
                }
                break
            default:
                break
        }
        
        // 그래프에 선 추가
        layer.frame = replayGraphView.bounds
        layer.path = line.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokColor.cgColor
        layer.lineWidth = 1.2
        
        switch option {
        case .measurement:
            if accView.isHidden == false {
                accGraphView.layer.addSublayer(layer)
            } else {
                gyroGraphView.layer.addSublayer(layer)
            }
            break
        default:
            replayGraphView.layer.addSublayer(layer)
            break
        }
    }
    
    /**
        그래프 뷰를 초기화 합니다.
     */
    public func resetGraph() {
        graphBaseHeight = graphViewHeight / 2.0 - 5.6
        index = 0 // index 초기화
        interval = 0.0
        multiplier = 1.0
        maxOffset = 0
        graphData.removeAll(keepingCapacity: false)
        
        // x, y, z 점 위치 초기화
        xLine = UIBezierPath()
        xLine.move(to: CGPoint(x: 5, y: graphBaseHeight))
        yLine = UIBezierPath()
        yLine.move(to: CGPoint(x: 5, y: graphBaseHeight))
        zLine = UIBezierPath()
        zLine.move(to: CGPoint(x: 5, y: graphBaseHeight))
        
        xOffsetLabel.text = "x: \(String(format: "%0.f", 0))"
        yOffsetLabel.text = "y: \(String(format: "%0.f", 0))"
        zOffsetLabel.text = "z: \(String(format: "%0.f", 0))"
        
        xLineLayer.removeFromSuperlayer()
        yLineLayer.removeFromSuperlayer()
        zLineLayer.removeFromSuperlayer()
    }
    
    class GraphView: UIView {
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            let pathLine = UIBezierPath()
            let boundsWidth = bounds.width / 8
            let boundsHeight = bounds.height / 8
            
            pathLine.move(to: CGPoint(x: 5, y: 5))
            pathLine.addLine(to: CGPoint(x: 5, y: bounds.height-5))
            for i in 1..<8 {
                pathLine.move(to: CGPoint(x: (Int(boundsWidth) * i)+5, y: 5))
                pathLine.addLine(to: CGPoint(x: (Int(boundsWidth) * i)+5, y: Int(bounds.height)-5))
            }
            pathLine.move(to: CGPoint(x: bounds.width-5, y: 5))
            pathLine.addLine(to: CGPoint(x: bounds.width-5, y: bounds.height-5))

//            print(boundsWidth)
     
            pathLine.move(to: CGPoint(x: bounds.width-5, y: 5))
            pathLine.addLine(to: CGPoint(x: 5, y: 5))
            
            for i in 1..<8 {
                pathLine.move(to: CGPoint(x: bounds.width-5, y: boundsHeight*CGFloat(i)))
                pathLine.addLine(to: CGPoint(x: 5, y: Int(boundsHeight)*i))
            }
            pathLine.move(to: CGPoint(x: bounds.width-5, y: bounds.height-5))
            pathLine.addLine(to: CGPoint(x: 5, y: bounds.height-5))
            
            UIColor.black.setStroke()
            pathLine.stroke()
        }
    }
}
