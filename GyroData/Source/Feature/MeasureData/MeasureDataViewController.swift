//
//  MeasureDataViewController.swift
//  GyroData
//
//  Created by 신동오 on 2022/09/20.
//

import UIKit

class MeasureDataViewController: UIViewController {
        
    var isGyroOnScreen : Bool = false{
        didSet{
            if oldValue{
                gyroBtn.backgroundColor = .lightGray
                accBtn.backgroundColor = .gray
            }else{
                gyroBtn.backgroundColor = .gray
                accBtn.backgroundColor = .lightGray
            }
        }
    }
    
    lazy var gyroBtn : UIButton = {
        let btn = UIButton(primaryAction: UIAction(title:"Gyro",handler:{ _ in
            if !self.isGyroOnScreen {
                self.presentGyro()
                self.isGyroOnScreen.toggle()
            }
        }))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .lightGray
        return btn
    }()
    
    lazy var accBtn : UIButton = {
        let btn = UIButton(primaryAction: UIAction(title:"Acc",handler:{ _ in
            if self.isGyroOnScreen {
                self.presentAcc()
                self.isGyroOnScreen.toggle()
            }
        }))
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .gray
        return btn
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
    
    lazy var measureBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("측정", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    lazy var stopBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("정지", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    
    
    
    //dumyData
    var xPoints = [4,2,6,4,5,8,3,9,15,5,3,9,5]
    var yPoints = [7,21,3,6,9,1,2,3,14,8,1,6,7]
    var zPoints = [4,17,3,3,5,8,13,9,2,8,12,4,6]
    
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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "측정하기"
        self.view.backgroundColor = .white
        
        addViews(to: self.view, gyroBtn, accBtn, measureBtn, stopBtn)
        doNotTranslate( gyroBtn, accBtn,measureBtn, stopBtn)
        
        NSLayoutConstraint.activate([
            gyroBtn.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.width * 0.4 - 20),
            gyroBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            gyroBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            accBtn.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.width * 0.4 - 20),
            accBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            accBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            measureBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).constraintWithMultiplier(1.5),
            measureBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).constraintWithMultiplier(0.5),
            stopBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).constraintWithMultiplier(0.5),
            stopBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).constraintWithMultiplier(1.7)
        ])
        
        presentAcc()
        
        xLabel.text = "x = 10"
        yLabel.text = "y = 20"
        zLabel.text = "z = 30"
        
    }
    
    func presentGyro(){
        removeViews([acc,xLabel,yLabel,zLabel])
        addViews(to: self.view, gyro)
        addViews(to: gyro, xLabel,yLabel,zLabel)
        doNotTranslate(gyro,xLabel,yLabel,zLabel)
        NSLayoutConstraint.activate([
            gyro.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gyro.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gyro.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gyro.heightAnchor.constraint(equalTo: gyro.widthAnchor),
            xLabel.topAnchor.constraint(equalTo: gyro.topAnchor),
            xLabel.centerXAnchor.constraint(equalTo: gyro.centerXAnchor).constraintWithMultiplier(0.3),
            yLabel.topAnchor.constraint(equalTo: gyro.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: gyro.centerXAnchor),
            zLabel.topAnchor.constraint(equalTo: gyro.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: gyro.centerXAnchor).constraintWithMultiplier(1.7)
        ])
    }
    
    func presentAcc(){
        removeViews([gyro,xLabel,yLabel,zLabel])
        addViews(to: self.view, acc)
        addViews(to: acc, xLabel,yLabel,zLabel)
        doNotTranslate(acc,xLabel,yLabel,zLabel)
        NSLayoutConstraint.activate([
            acc.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            acc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            acc.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            acc.heightAnchor.constraint(equalTo: acc.widthAnchor),
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
        static let maxPoint : CGFloat = 25
    }
    
    //그라데이션을 위한 시작 색상과 끝 색상
    var startColor : UIColor = .lightGray
    var endColor   : UIColor = .gray
    
    var xPoints : [Int]
    var yPoints : [Int]
    var zPoints : [Int]
    
    // set up the points line
    let xPath = UIBezierPath()
    let yPath = UIBezierPath()
    let zPath = UIBezierPath()
    
    
    var xLineLayer = CAShapeLayer()
    var yLineLayer = CAShapeLayer()
    var zLineLayer = CAShapeLayer()
    
    
    
    
    
    
    
    
    
    
    
    init(xPoints:[Int], yPoints:[Int], zPoints:[Int]){
        
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
        let columnXPoint = { (column : Int) -> CGFloat in
            //gap between points
            let spacing = graphWidth / CGFloat(self.xPoints.count - 1)
            return CGFloat(column) * spacing + margin
        }
        
        //y-point 계산
        let topBorder    = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight  = height - topBorder - bottomBorder
        let maxValue     = Constants.maxPoint
        let columnYPoint = { (graphPoint : Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y
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
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(self.xPoints[i]))
            xPath.addLine(to: nextPoint)
        }
        
        
        //xPath.stroke()
        
        
        //점도 애니메이션 구현하기
        //        for i in 0..<xPoints.count {
        //            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(xPoints[i]))
        //            point.x -= Constants.circleDiameter / 2
        //            point.y -= Constants.circleDiameter / 2
        //
        //            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
        //
        //            circle.fill()
        //        }
        
        
        
        
        
        //draw the yline graph
        UIColor.green.setFill()
        UIColor.green.setStroke()
        
        
        //go to start of line
        yPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(yPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<yPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(yPoints[i]))
            yPath.addLine(to: nextPoint)
        }
        
        //yPath.stroke()
        
        //        for i in 0..<yPoints.count {
        //            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(yPoints[i]))
        //            point.x -= Constants.circleDiameter / 2
        //            point.y -= Constants.circleDiameter / 2
        //
        //            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
        //
        //            circle.fill()
        //        }
        
        
        
        
        
        
        //draw the zline graph
        UIColor.blue.setFill()
        UIColor.blue.setStroke()
        
        
        //go to start of line
        zPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(zPoints[0])))
        
        //add points for each item in the xPoints array
        //at the correct (x,y) for the point
        for i in 1..<zPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(zPoints[i]))
            zPath.addLine(to: nextPoint)
        }
        
        //zPath.stroke()
        
        //        for i in 0..<yPoints.count {
        //            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(zPoints[i]))
        //            point.x -= Constants.circleDiameter / 2
        //            point.y -= Constants.circleDiameter / 2
        //
        //            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
        //
        //            circle.fill()
        //        }
        
        
        //draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: margin, y: columnYPoint(0) ))
        linePath.addLine(to: CGPoint(x: width - margin, y: columnYPoint(0) ))
        
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
        xLineLayer.lineWidth = 2
        self.layer.addSublayer(xLineLayer)
        
        yLineLayer.path = yPath.cgPath
        yLineLayer.strokeColor = UIColor.green.cgColor
        yLineLayer.fillColor = nil
        yLineLayer.lineWidth = 2
        self.layer.addSublayer(yLineLayer)
        
        zLineLayer.path = zPath.cgPath
        zLineLayer.strokeColor = UIColor.blue.cgColor
        zLineLayer.fillColor = nil
        zLineLayer.lineWidth = 2
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


