//
//  MeasureDataViewController.swift
//  GyroData
//
//  Created by 신동오 on 2022/09/20.
//

import UIKit
import CoreMotion

class MeasureDataViewController: UIViewController {
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isGyroOnScreen : Bool = false
    var isMeasuring: Bool = false
    let motion = CMMotionManager()
    var accTimer: Timer?
    var gyroTimer: Timer?
    let segAttributes: NSDictionary = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
    ]
    var measureTime = 0
    var motionXArray = [Double]()
    var motionYArray = [Double]()
    var motionZArray = [Double]()
    var startDate = ""
    var dataType = ""

    lazy var segmentedControl: UISegmentedControl = {
      let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentTintColor = .systemBlue
        control.backgroundColor = .gray
        control.addTarget(self, action: #selector(segconChange), for: .touchUpInside)
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes(segAttributes as? [NSAttributedString.Key : Any], for: .disabled)
      return control
    }()
    
    @objc func segconChange(_ secong: UISegmentedControl){
        if !isMeasuring {
            if secong.selectedSegmentIndex == 0 {
                presentAcc()
                isGyroOnScreen.toggle()
            } else{
                presentGyro()
                isGyroOnScreen.toggle()
            }
        }
    }
    
    //dumyData
    var xPoints : [Double]{
        var arr = [Double]()
        for _ in 0..<600{
            arr.append(Double.random(in: -40..<40))
        }
        return arr
    }
    var yPoints : [Double]{
        var arr = [Double]()
        for _ in 0..<600{
            arr.append(Double.random(in: -40..<40))
        }
        return arr
    }
    var zPoints : [Double]{
        var arr = [Double]()
        for _ in 0..<600{
            arr.append(Double.random(in: -40..<40))
        }
        return arr
    }
    
    lazy var measureBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("측정", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var stopBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("정지", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.customView = self.saveBtn
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    lazy var xLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        return lbl
    }()
    lazy var yLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .green
        return lbl
    }()
    lazy var zLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    
    
    
    lazy var gyro : GraphView = {
        let view = GraphView(xPoints: xPoints, yPoints: yPoints, zPoints: zPoints)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var acc : GraphView = {
        let view = GraphView(xPoints: zPoints.reversed(), yPoints: xPoints.reversed(), zPoints: yPoints.reversed())
        view.backgroundColor = .clear
        return view
    }()
    
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.layer.zPosition = 1
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "측정하기"
        self.view.backgroundColor = .white
        self.navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
        
        addViews(to: self.view, segmentedControl, measureBtn, stopBtn)
        doNotTranslate(segmentedControl,measureBtn, stopBtn)
        
        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.width * 0.4 - 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            measureBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).constraintWithMultiplier(1.5),
            measureBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).constraintWithMultiplier(0.5),
            stopBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).constraintWithMultiplier(0.5),
            stopBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).constraintWithMultiplier(1.7)
        ])
        
        presentAcc()
        
        xLabel.text = "x = 0"
        yLabel.text = "y = 0"
        zLabel.text = "z = 0"
        
    }
    
    func presentGyro(){
        removeViews([acc,xLabel,yLabel,zLabel, activityIndicator])
        addViews(to: self.view, gyro)
        addViews(to: gyro, xLabel,yLabel,zLabel, activityIndicator)
        doNotTranslate(gyro,xLabel,yLabel,zLabel, activityIndicator)
        NSLayoutConstraint.activate([
            gyro.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gyro.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gyro.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gyro.heightAnchor.constraint(equalTo: gyro.widthAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: gyro.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: gyro.centerXAnchor),
            xLabel.topAnchor.constraint(equalTo: gyro.topAnchor),
            xLabel.centerXAnchor.constraint(equalTo: gyro.centerXAnchor).constraintWithMultiplier(0.3),
            yLabel.topAnchor.constraint(equalTo: gyro.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: gyro.centerXAnchor),
            zLabel.topAnchor.constraint(equalTo: gyro.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: gyro.centerXAnchor).constraintWithMultiplier(1.7)
        ])
    }
    
    func presentAcc(){
        removeViews([gyro,xLabel,yLabel,zLabel, activityIndicator])
        addViews(to: self.view, acc)
        addViews(to: acc, xLabel,yLabel,zLabel,activityIndicator)
        doNotTranslate(acc,xLabel,yLabel,zLabel,activityIndicator)
        NSLayoutConstraint.activate([
            acc.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            acc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acc.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            acc.heightAnchor.constraint(equalTo: acc.widthAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: acc.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: acc.centerXAnchor),
            xLabel.topAnchor.constraint(equalTo: acc.topAnchor),
            xLabel.centerXAnchor.constraint(equalTo: acc.centerXAnchor).constraintWithMultiplier(0.3),
            yLabel.topAnchor.constraint(equalTo: acc.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: acc.centerXAnchor),
            zLabel.topAnchor.constraint(equalTo: acc.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: acc.centerXAnchor).constraintWithMultiplier(1.7)
        ])
    }
    
    func removeViews(_ views:[UIView]){
        _ = views.map{$0.removeFromSuperview()}
    }
    
    func addViews(to:UIView,_ views:UIView...){
        views.forEach{to.addSubview($0)}
    }
    
    func doNotTranslate(_ views:UIView...){
        views.forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
    }

    func initMeasureDatas(type: String) {
        measureTime = 0
        motionXArray.removeAll()
        motionYArray.removeAll()
        motionZArray.removeAll()
        dataType = type
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-M-d_HH:mm:ss"
        startDate = dateFormatter.string(from: date)

    }
    
    func startAccelerometers() {
        initMeasureDatas(type: "Accelerometer")

        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 0.1
            motion.startAccelerometerUpdates()

            self.accTimer = Timer(fire: Date(), interval: 0.1,
                                  repeats: true, block: { (timer) in
                if self.measureTime == 600 { self.buttonTapAction(self.stopBtn) }

                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    self.xLabel.text = "x = \(String(format: "%.2f", x))"
                    self.yLabel.text = "y = \(String(format: "%.2f", y))"
                    self.zLabel.text = "z = \(String(format: "%.2f", z))"

                    self.motionXArray.append(x)
                    self.motionYArray.append(y)
                    self.motionZArray.append(z)

                    self.measureTime += 1
                }
            })
            if let timer = accTimer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }

    func startGyroscope() {
        initMeasureDatas(type: "Gyro")

        if motion.isGyroAvailable {
            motion.gyroUpdateInterval = 0.1
            motion.startGyroUpdates()
            
            self.gyroTimer = Timer(fire: Date(), interval: 0.1,
                                   repeats: true, block: { (timer) in
                if self.measureTime == 600 { self.buttonTapAction(self.stopBtn) }

                if let data = self.motion.gyroData {
                    let x = data.rotationRate.x
                    let y = data.rotationRate.y
                    let z = data.rotationRate.z
                    self.xLabel.text = "x = \(String(format: "%.2f", x))"
                    self.yLabel.text = "y = \(String(format: "%.2f", y))"
                    self.zLabel.text = "z = \(String(format: "%.2f", z))"

                    self.motionXArray.append(x)
                    self.motionYArray.append(y)
                    self.motionZArray.append(z)

                    self.measureTime += 1
                }
            })
            if let timer = gyroTimer {
                RunLoop.current.add(timer, forMode: .default)
            }
        }
    }
    
    func stopMeasuring(_ timer: Timer?) {
        timer?.invalidate()
    }

    func saveMeasuredData() {
        activityIndicator.startAnimating()
        // Core Data
        let motionData = MotionData(context: self.context)
        motionData.measureTime = String(Double(measureTime) / 10.0)
        motionData.date = startDate
        motionData.dataType = dataType
        motionData.motionX = motionXArray
        motionData.motionY = motionYArray
        motionData.motionZ = motionZArray

        // FileManager

        let motionInfo = MotionInfo(date: startDate,
                                    dataType: dataType,
                                    measureTime: String(Double(measureTime) / 10.0),
                                    motionX: motionXArray,
                                    motionY: motionYArray,
                                    motionZ: motionZArray)
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            do {
                try self.context.save()
            } catch {
                DispatchQueue.main.async {
                    self.setAlert(message: error.localizedDescription)
                }
            }
        }
        
        DispatchQueue.global().async(group: group) {
            do {
                try FileService.shared.saveJSON(data: motionInfo)
            } catch {
                DispatchQueue.main.async {
                    self.setAlert(message: error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.setAlertAndFinish(message: "저장이 완료되었습니다.")
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setAlertAndFinish(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case measureBtn:
            if self.segmentedControl.selectedSegmentIndex == 0 {
                startAccelerometers()
                self.segmentedControl.setEnabled(false, forSegmentAt: 1)
            } else {
                startGyroscope()
                self.segmentedControl.setEnabled(false, forSegmentAt: 0)
            }
            measureBtn.isEnabled = false
            saveBarButtonItem.isEnabled = true
            isMeasuring = true
        case stopBtn:
            if self.segmentedControl.selectedSegmentIndex == 0 {
                stopMeasuring(accTimer)
                self.segmentedControl.setEnabled(true, forSegmentAt: 1)
            } else {
                stopMeasuring(gyroTimer)
                self.segmentedControl.setEnabled(true, forSegmentAt: 0)
            }
            isMeasuring = false
            measureBtn.isEnabled = true
        case saveBtn:
            saveMeasuredData()
        default:
            return
        }
    }
    
}





class GraphView : UIView {
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 20.0, height: 20.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.7
        static let colorAlphaForSubLine : CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
        static let maxPoint : CGFloat = 80
    }
    
    //그라데이션을 위한 시작 색상과 끝 색상
    var startColor : UIColor = .lightGray
    var endColor   : UIColor = .gray
    
    var xPoints : [Double]
    var yPoints : [Double]
    var zPoints : [Double]
    
    // set up the points line
    let xPath = UIBezierPath()
    let yPath = UIBezierPath()
    let zPath = UIBezierPath()
    
    
    var xLineLayer = CAShapeLayer()
    var yLineLayer = CAShapeLayer()
    var zLineLayer = CAShapeLayer()
    
    
    
    
    
    
    
    
    
    
    
    init(xPoints:[Double], yPoints:[Double], zPoints:[Double]){
        
        self.xPoints = xPoints
        self.yPoints = yPoints
        self.zPoints = zPoints
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let width  = rect.width
        let height = rect.height
        
        //x-point 계산
        let margin = Constants.margin
        let graphWidth = width - margin * 2
        let columnXPoint = { (column : Double) -> CGFloat in
            //gap between points
            let spacing = graphWidth / CGFloat(self.xPoints.count - 1)
            return CGFloat(column) * spacing + margin
        }
        
        //y-point 계산
        let topBorder    = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight  = height - topBorder - bottomBorder
        let maxValue     = Constants.maxPoint
        let columnYPoint = { (graphPoint : Double) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight / 2 + topBorder - y
        }
        
        
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        //CG drawing 함수는 이들이 그리는 context를 알아야 하므로 UIKit 메소드 UIGraphicsGetCurrentContext()를 사용하여 현재 컨텍스트를 가져온다. UIGraphicsGetCurrentContext()는 draw(_:)가 그린것이다
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //모든 context는 color space를 가진다. 색상 공간은 CMYK, grayscale 일 수 있지만, 여기서는 RGB 색상 공간을 사용하고 있다
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //color stops(변수명 colorLocation)은 그라데이션 색상이 변경되는 위치를 나타낸다. 3개의 점도 가질 수 있다
        let colorLocations : [CGFloat] = [0.0, 1.0]
        
        //실제 그라데이션, 색상공간, 색상들, 색상 정지(color stops)을 생성
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray , locations: colorLocations)!
        
        //그라데이션을 그린다
        let startPoint = CGPoint.zero
        let endPoint   = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        //그라데이션은 draw(_:)의 전체 사각형을 채운다
        
        
        
        //draw the xline graph
        UIColor.red.setFill()
        UIColor.red.setStroke()
        
        
        //go xPath start of line
        xPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(self.xPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<self.xPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(self.xPoints[i]))
            xPath.addLine(to: nextPoint)
        }
        
        
        //xPath.stroke()

        
        
        
        
        //draw the yline graph
        UIColor.green.setFill()
        UIColor.green.setStroke()
        
        
        //go to start of line
        yPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<yPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(yPoints[i]))
            yPath.addLine(to: nextPoint)
        }
        
        //yPath.stroke()
        
    
        
        //draw the zline graph
        UIColor.blue.setFill()
        UIColor.blue.setStroke()
        
        
        //go to start of line
        zPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(zPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<zPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(Double(i)), y: columnYPoint(zPoints[i]))
            zPath.addLine(to: nextPoint)
        }
        
        //zPath.stroke()
        
        
        //draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: margin, y: graphHeight / 2 + topBorder ))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2 + topBorder ))
        
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: margin, y: graphHeight + topBorder))
        
        
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        
        
        
        //animation
        
        xLineLayer.path = xPath.cgPath
        xLineLayer.strokeColor = UIColor.red.cgColor
        xLineLayer.fillColor = nil
        xLineLayer.lineWidth = 0.5
        self.layer.addSublayer(xLineLayer)
        
        yLineLayer.path = yPath.cgPath
        yLineLayer.strokeColor = UIColor.green.cgColor
        yLineLayer.fillColor = nil
        yLineLayer.lineWidth = 0.5
        self.layer.addSublayer(yLineLayer)
        
        zLineLayer.path = zPath.cgPath
        zLineLayer.strokeColor = UIColor.blue.cgColor
        zLineLayer.fillColor = nil
        zLineLayer.lineWidth = 0.5
        self.layer.addSublayer(zLineLayer)
        
    }
    
    func startGraphDrawing(){
        
        xPath.removeAllPoints()
        
        // strokeEnd -> 끝 점 지정 0-1까지의 값을 가짐
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        
        xLineLayer.add(animation, forKey: "lineAnimation")
        yLineLayer.add(animation, forKey: "lineAnimation")
        zLineLayer.add(animation, forKey: "lineAnimation")
        
    }
    
    func pauseAnimation(){
        var pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
      layer.speed = 0.0
      layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
      var pausedTime = layer.timeOffset
      layer.speed = 1.0
      layer.timeOffset = 0.0
      layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
      layer.beginTime = timeSincePause
    }
        
}


