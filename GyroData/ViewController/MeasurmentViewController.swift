//
//  MeasurmentViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreMotion

class MeasurmentViewController: UIViewController {
    
    //Acc, gyro manager
    let manager = CMMotionManager()
    
    /// 센서 측정 타이머
    lazy var timer = Timer()
    lazy var accTimer = Timer()
    lazy var timeoutTimer = Timer()

    // 그래프 뷰의 size
    let graphViewHeight: CGFloat = 280.0
    let graphViewWidth: CGFloat = 280.0

    // 1개의 데이터가 차지할 width
    var blockWidth: CGFloat = 0.0

    //데이터
    var xData = [Float]()
    var yData = [Float]()
    var zData = [Float]()

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
    
    // 타임 라벨에 표시될 시간
    var interval: Float = 0.0
    var time: Float = 0.0
    var timeLeft = 600.0
    
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
        view.backgroundColor = .black
        return view
    }()
    
    lazy var gyroView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      return view
    }()
    
    var graphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .white
        return view
    }()
    
    var gyroGraphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var measurementButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("측정", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
        button.addTarget(self, action: #selector(measurement), for: .touchUpInside)
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

    /// 측정을 위한 타이머 실행
    @objc func measurement() {
        manager.startGyroUpdates()
        manager.startAccelerometerUpdates()
        
        //업데이트 간격
        manager.accelerometerUpdateInterval = 0.1
        manager.gyroUpdateInterval = 0.1
        
        accTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            
            if self.accView.isHidden == false {
                if let data = self.manager.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z

                    self.xData.append(Float(x) * 10)
                    self.yData.append(Float(y) * 10)
                    self.zData.append(Float(z) * 10)
                    print("x: \(x), y: \(y), z: \(z)")
                }

            } else {
                if let gyrodata = self.manager.gyroData {
                    let x = gyrodata.rotationRate.x
                    let y = gyrodata.rotationRate.y
                    let z = gyrodata.rotationRate.z
                    
                    self.xData.append(Float(x))
                    self.yData.append(Float(y))
                    self.zData.append(Float(z))
                    print("x: \(x), y: \(y), z: \(z)")
                }
            }
        }
        // 0.1초마다 측정을위한 타이머 설정
        resetGraph() // 시작 시 초기화
        print("timer scheduling..")
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGraph), userInfo: nil, repeats: true)
        
    }

    /// 그래프 업데이트
    @objc func updateGraph() {
        
        if timeLeft == 0 {
            resetGraph()
            timer.invalidate()
            accTimer.invalidate()
            
            //전체 시간
            time = interval
            print(time)
            interval = 0
        } else {
            // 타이머 라벨 update
            self.interval += Float(timer.timeInterval)
            //print("\(self.interval)")
            
            
            // 한개의 점이 차지할 width
            self.blockWidth = self.graphViewHeight/600.0
            
            // 각 x, y, z 레이어 add
            addLayer(xLine, xLineLayer, index, .red)
            addLayer(yLine, yLineLayer, index, .green)
            addLayer(zLine, zLineLayer, index, .blue)
            
            // 다음 점 표시를 위한 index 증감
            index += 1
            
            //60초
            timeLeft -= 1
            print(timeLeft)
        }
    }

    // garphView에 lineLayer를 추가
    func addLayer(_ line: UIBezierPath, _ layer: CAShapeLayer, _ index: Int, _ strokColor: UIColor) {
        var xyOffset: Float = 0.0
        var yyOffset: Float = 0.0
        var zyOffset: Float = 0.0
        
        switch line {
            case xLine:
            xyOffset = Float(xData[index])
                break
            case yLine:
            yyOffset = Float(yData[index])
                break
            case zLine:
            zyOffset = Float(zData[index])
                break
            default:
                break
        }
        let x = CGFloat((index+1)) * blockWidth
        let xy = CGFloat(120.0-xyOffset)
        let yy = CGFloat(140.0-yyOffset)
        let zy = CGFloat(160.0-zyOffset)
        
        xLine.addLine(to: CGPoint(x: x+5, y: xy))
        yLine.addLine(to: CGPoint(x: x+5, y: yy))
        zLine.addLine(to: CGPoint(x: x+5, y: zy))
            
        layer.frame = graphView.bounds
        layer.path = line.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = strokColor.cgColor
        layer.lineWidth = 1.5
        
        if accView.isHidden == false {
            graphView.layer.addSublayer(layer)
        } else {
            gyroGraphView.layer.addSublayer(layer)
        }
    }

    // 그래프 초기화
    func resetGraph() {
        print("reset graph")
        index = 0 // index 초기화
        
        // x, y, z 점 위치 초기화
        xLine = UIBezierPath()
        xLine.move(to: CGPoint(x: 5, y: 120))
        yLine = UIBezierPath()
        yLine.move(to: CGPoint(x: 5, y: 140))
        zLine = UIBezierPath()
        zLine.move(to: CGPoint(x: 5, y: 160))
        
        // 각 선 layer graphView로부터 제거
        lineLayer.removeFromSuperlayer()
        xLineLayer.removeFromSuperlayer()
        yLineLayer.removeFromSuperlayer()
        zLineLayer.removeFromSuperlayer()

    }
    
    @objc func saveButtonPressed() {
        // 데이터 저장
        if interval == 0 {
            print(xData)
            print(yData)
            print(zData)
            print(time)
        } else {
            let alert = UIAlertController(title: "측정 중 데이터 저장불가", message: "확인을 눌러주새요.", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func stopPressed() {
        if interval == 0 {
            print("실행 상태가 아닙니다.")
        } else {
            index = 0 // index 초기화
            
            // x, y, z 점 위치 초기화
            xLine = UIBezierPath()
            xLine.move(to: CGPoint(x: 5, y: 120))
            yLine = UIBezierPath()
            yLine.move(to: CGPoint(x: 5, y: 140))
            zLine = UIBezierPath()
            zLine.move(to: CGPoint(x: 5, y: 160))
            
            // 각 선 layer graphView로부터 제거
            lineLayer.removeFromSuperlayer()
            xLineLayer.removeFromSuperlayer()
            yLineLayer.removeFromSuperlayer()
            zLineLayer.removeFromSuperlayer()
            
            print("timer invalidated")
            timer.invalidate()
            accTimer.invalidate()
            
            //전체 시간
            time = interval
            print(time)
            interval = 0
        }
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        if interval == 0 {
            self.shouldHideFirstView = segment.selectedSegmentIndex != 0
        } else {
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

        print(boundsWidth)
 
        
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


