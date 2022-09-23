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
        control.addTarget(self, action: #selector(segconChange), for: .valueChanged)
        control.selectedSegmentIndex = 0
      return control
    }()
    
    @objc func segconChange(_ secong: UISegmentedControl){
            if secong.selectedSegmentIndex == 0 {
                containerView.exchangeSubview(at: 0, withSubviewAt: 1)
                gyroView.isHidden = true
                accView.isHidden = false
                setTextsIndicateLabels(max: Constants.accMax, min: -Constants.accMax)
            } else{
                containerView.exchangeSubview(at: 1, withSubviewAt: 0)
                gyroView.isHidden = false
                accView.isHidden = true
                setTextsIndicateLabels(max: Constants.gyroMax, min: -Constants.gyroMax)
            }
    }
    
    var isPlaying : Bool = false{
        didSet{
            if isPlaying{
                segmentedControl.isEnabled = false
                measureBtn.isEnabled = false
                stopBtn.isEnabled = true
            }else{
                segmentedControl.isEnabled = true
                measureBtn.isEnabled = true
                stopBtn.isEnabled = false
            }
        }
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
    lazy var maxLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .init(white: 0.8, alpha: 1)
        lbl.layer.cornerRadius = 5
        lbl.layer.masksToBounds = true
        return lbl
    }()
    lazy var minLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .init(white: 0.2, alpha: 1)
        lbl.layer.cornerRadius = 5
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    
    
    
    
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let plot : PlotView = {
       let view = PlotView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var gyroView : RealTimeGraph = {
        let view = RealTimeGraph()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var accView : RealTimeGraph = {
        let view = RealTimeGraph()
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
        accView.erase()
        var max = Constants.accMax
        setTextsIndicateLabels(max : max, min : -max)
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
                        
                        self.motionXArray.append(x)
                        self.motionYArray.append(y)
                        self.motionZArray.append(z)
             

                        if self.motion.isAccelerometerActive{
                            self.xLabel.text = "x:\(String(format:"%.2f",x))"
                            self.yLabel.text = "y:\(String(format:"%.2f",y))"
                            self.zLabel.text = "z:\(String(format:"%.2f",z))"
                        }
                        self.accView.xPoint = x
                        self.accView.yPoint = y
                        self.accView.zPoint = z
                                                
                        if abs(x) > max || abs(y) > max || abs(z) > max {
                            self.accView.isOverflow = true
                            Constants.calibration *= 1.2
                            max *= 1.2
                            self.setTextsIndicateLabels(max: max, min: -max)
                        }
                        
                        self.accView.setNeedsDisplay()
                        
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
        gyroView.erase()
        var max = Constants.gyroMax
        setTextsIndicateLabels(max: max, min: -max)
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
                        
                        
                        self.motionXArray.append(x)
                        self.motionYArray.append(y)
                        self.motionZArray.append(z)
           
                        if self.motion.isGyroActive{
                            self.xLabel.text = "x:\(String(format:"%.2f",x))"
                            self.yLabel.text = "y:\(String(format:"%.2f",y))"
                            self.zLabel.text = "z:\(String(format:"%.2f",z))"
                        }
                        
                        self.gyroView.xPoint = x
                        self.gyroView.yPoint = y
                        self.gyroView.zPoint = z
                        
                        if abs(x) > max || abs(y) > max || abs(z) > max {
                            self.accView.isOverflow = true
                            Constants.calibration *= 1.2
                            max *= 1.2
                            self.setTextsIndicateLabels(max: max, min: -max)
                        }
                        
                        self.gyroView.setNeedsDisplay()
                        
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
        
        let motionData = MotionData(context: self.context)
        motionData.measureTime = String(Double(measureTime) / 10.0)
        motionData.date = startDate
        motionData.dataType = dataType
        motionData.motionX = motionXArray
        motionData.motionY = motionYArray
        motionData.motionZ = motionZArray


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
            } else {
                startGyroscope()
            }
            self.segmentedControl.isEnabled = false
            saveBarButtonItem.isEnabled = true
            isPlaying = true
        case stopBtn:
            if self.segmentedControl.selectedSegmentIndex == 0 {
                stopMeasuring(accTimer)
            } else {
                stopMeasuring(gyroTimer)
            }
            self.segmentedControl.isEnabled = true
            isPlaying = false
        case saveBtn:
            saveMeasuredData()
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "측정하기"
        self.view.backgroundColor = .white
        self.navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
        
        addViews(to: self.view,plot, segmentedControl, measureBtn, stopBtn, containerView)
        doNotTranslate(segmentedControl,measureBtn, stopBtn, containerView,plot)
        addSubViews(gyroView,accView)
        addXYZLabels(xLabel,yLabel,zLabel)
        addIndicateLabels(maxLabel,minLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            plot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plot.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            plot.heightAnchor.constraint(equalTo: plot.widthAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -view.frame.width * 0.4 - 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            measureBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).constraintWithMultiplier(1.5),
            measureBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).constraintWithMultiplier(0.5),
            stopBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).constraintWithMultiplier(0.5),
            stopBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).constraintWithMultiplier(1.7),
            maxLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).constraintWithMultiplier(2/8),
            minLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).constraintWithMultiplier(14/8),
            xLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(0.5),
            yLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            zLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(1.5),
        ])
                
        setLabelsToZero()
        
    }

    func setLabelsToZero(){
        xLabel.text = "x: 0.00"
        yLabel.text = "y: 0.00"
        zLabel.text = "z: 0.00"
    }
    
    func setTextsIndicateLabels(max:Double,min:Double){
        maxLabel.text = " max:" + String(format:"%.2f",max) + " "
        minLabel.text = " min:" + String(format:"%.2f",min) + " "
    }
    
    func addXYZLabels(_ label:UILabel...){
        label.forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        }
    }
    
    func addSubViews(_ view:UIView...){
        view.forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                $0.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                $0.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            ])
        }
    }
    
    func addIndicateLabels(_ label:UILabel...){
        label.forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(1.7).isActive = true
        }
    }
    
}



