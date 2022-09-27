//
//  MeasureDataViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit
import CoreMotion

class MeasureDataViewController: UIViewController {
        
    var isGyroOnScreen : Bool = false
    var isMeasuring: Bool = false
    let motion = CMMotionManager()
    var accTimer: Timer?
    var gyroTimer: Timer?
    var measureTime = 0
    var motionXArray = [Double]()
    var motionYArray = [Double]()
    var motionZArray = [Double]()
    var startDate = ""
    var dataType = ""
    
    var isPlaying : Bool = false{
        didSet{
            if isPlaying{
                segmentedControl.isEnabled = false
                measureButton.isEnabled = false
                stopButton.isEnabled = true
            }else{
                segmentedControl.isEnabled = true
                measureButton.isEnabled = true
                stopButton.isEnabled = false
            }
        }
    }
    
    lazy var segmentedControl: UISegmentedControl = {
      let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentTintColor = .systemBlue
        control.backgroundColor = .secondarySystemBackground
        control.addTarget(self, action: #selector(segconChange), for: .valueChanged)
        control.selectedSegmentIndex = 0
      return control
    }()
    
    lazy var measureButton : UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stopButton : UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        return button
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.customView = self.saveButton
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    var xLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        return lbl
    }()
    
    var yLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .green
        return lbl
    }()
    
    var zLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    
    var maxLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.backgroundColor = .init(white: 0.8, alpha: 1)
        lbl.layer.cornerRadius = 5
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    var minLabel : UILabel = {
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
    
    lazy var gyroView : GraphView = {
        let view = GraphView(id: .measure, xPoints: [0.0], yPoints: [0.0], zPoints: [0.0])
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var accView : GraphView = {
        let view = GraphView(id: .measure, xPoints: [0.0], yPoints: [0.0], zPoints: [0.0])
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
        setProperties()
        addViews()
        setConstraints()
        setLabelValue(x: 0.0, y: 0.0, z: 0.0)
        setTextsIndicateLabels(max: Constants.accMax, min: -Constants.accMax)
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
        accView.drawable = true
        var max = Constants.accMax
        setTextsIndicateLabels(max : max, min : -max)
        if motion.isAccelerometerAvailable {
                motion.accelerometerUpdateInterval = 0.1
                motion.startAccelerometerUpdates()
                self.accTimer = Timer(fire: Date(), interval: 0.1,
                                      repeats: true, block: { (timer) in
                    if self.measureTime == 599 { self.buttonTapAction(self.stopButton) }
                    if let data = self.motion.accelerometerData {
                        let x = data.acceleration.x
                        let y = data.acceleration.y
                        let z = data.acceleration.z
                        
                        self.motionXArray.append(x)
                        self.motionYArray.append(y)
                        self.motionZArray.append(z)
             
                        self.setLabelValue(x: x, y: y, z: z)
                        self.accView.getData(x: x, y: y, z: z)
                                                
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
        gyroView.drawable = true
        var max = Constants.gyroMax
        setTextsIndicateLabels(max: max, min: -max)
        if motion.isGyroAvailable {
                motion.gyroUpdateInterval = 0.1
                motion.startGyroUpdates()
                self.gyroTimer = Timer(fire: Date(), interval: 0.1,
                                       repeats: true, block: { (timer) in
                    if self.measureTime == 599 { self.buttonTapAction(self.stopButton) }
                    if let data = self.motion.gyroData {
                        let x = data.rotationRate.x
                        let y = data.rotationRate.y
                        let z = data.rotationRate.z
       
                        self.motionXArray.append(x)
                        self.motionYArray.append(y)
                        self.motionZArray.append(z)
                        
                        self.setLabelValue(x: x, y: y, z: z)
                        self.gyroView.getData(x: x, y: y, z: z)
     
                        if abs(x) > max || abs(y) > max || abs(z) > max {
                            self.gyroView.isOverflow = true
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
        
        let motionData = MotionData(context: CoreDataService.shared.context)
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
            CoreDataService.shared.saveContext()
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
        self.setLabelValue(x: 0.0, y: 0.0, z: 0.0)
    }
    
    @objc func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case measureButton:
            if segmentedControl.selectedSegmentIndex == 0 {
                startAccelerometers()
            } else {
                startGyroscope()
            }
            segmentedControl.isEnabled = false
            saveBarButtonItem.isEnabled = false
            isPlaying = true
        case stopButton:
            if self.segmentedControl.selectedSegmentIndex == 0 {
                stopMeasuring(accTimer)
            } else {
                stopMeasuring(gyroTimer)
            }
            segmentedControl.isEnabled = true
            saveBarButtonItem.isEnabled = true
            isPlaying = false
        case saveButton:
            saveMeasuredData()
        default:
            return
        }
    }
    
    func setProperties() {
        self.title = "측정하기"
        self.view.backgroundColor = .white
        self.navigationItem.setRightBarButton(saveBarButtonItem, animated: true)
    }
    
    func addViews(){
        view.addSubviews(plot, containerView, segmentedControl, measureButton, stopButton)
        containerView.addSubviews(accView, gyroView, xLabel, yLabel, zLabel, maxLabel, minLabel)
        
        [plot, containerView, segmentedControl, measureButton, stopButton, accView, gyroView, xLabel, yLabel, zLabel, maxLabel, minLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            plot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plot.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            plot.heightAnchor.constraint(equalTo: plot.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            measureButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            measureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stopButton.topAnchor.constraint(equalTo: measureButton.bottomAnchor, constant: 20),
            stopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            accView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            accView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            accView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            accView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            gyroView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            gyroView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            gyroView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            gyroView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            maxLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).constraintWithMultiplier(2/8),
            maxLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(1.7),
            minLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).constraintWithMultiplier(14/8),
            minLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(1.7),
            xLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(0.5),
            xLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            yLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).constraintWithMultiplier(1.5),
            zLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
        ])
    }

    func setLabelValue(x:Double, y:Double, z:Double){
        xLabel.text = "x:" + String(format:"%.2f",x)
        yLabel.text = "y:" + String(format:"%.2f",y)
        zLabel.text = "z:" + String(format:"%.2f",z)
    }
    
    func setTextsIndicateLabels(max:Double, min:Double){
        maxLabel.text = " max:" + String(format:"%.2f",max) + " "
        minLabel.text = " min:" + String(format:"%.2f",min) + " "
    }
}




