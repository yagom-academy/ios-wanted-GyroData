//
//  MeasureDataViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit
import CoreMotion

class MeasureDataViewController: UIViewController {
    
    let measureDataView = MeasureDataView()
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
                measureDataView.segmentedControl.isEnabled = false
                measureDataView.measureButton.isEnabled = false
                measureDataView.stopButton.isEnabled = true
            }else{
                measureDataView.segmentedControl.isEnabled = true
                measureDataView.measureButton.isEnabled = true
                measureDataView.stopButton.isEnabled = false
            }
        }
    }
    
    override func loadView() {
        self.view = measureDataView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        setTarget()
        setLabelValue(x: 0.0, y: 0.0, z: 0.0)
        setTextsIndicateLabels(max: Constants.accMax, min: -Constants.accMax)
    }
    
    func setProperties() {
        self.title = "측정하기"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.setRightBarButton(measureDataView.saveBarButtonItem, animated: true)
    }

    func setTarget() {
        [measureDataView.measureButton, measureDataView.saveButton, measureDataView.stopButton].forEach {
            $0.addTarget(self, action: #selector(buttonTapAction), for: .touchUpInside)
        }
        
        measureDataView.segmentedControl.addTarget(self, action: #selector(segconChange), for: .valueChanged)
    }
    
    func setLabelValue(x:Double, y:Double, z:Double){
        measureDataView.xLabel.text = "x:" + String(format:"%.2f",x)
        measureDataView.yLabel.text = "y:" + String(format:"%.2f",y)
        measureDataView.zLabel.text = "z:" + String(format:"%.2f",z)
    }
    
    func setTextsIndicateLabels(max:Double, min:Double){
        measureDataView.maxLabel.text = " max:" + String(format:"%.2f",max) + " "
        measureDataView.minLabel.text = " min:" + String(format:"%.2f",min) + " "
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
        measureDataView.accView.erase()
        measureDataView.accView.drawable = true
        var max = Constants.accMax
        measureDataView.accView.max = Constants.accMax
        setTextsIndicateLabels(max : max, min : -max)
        if motion.isAccelerometerAvailable {
                motion.accelerometerUpdateInterval = 0.1
                motion.startAccelerometerUpdates()
                self.accTimer = Timer(fire: Date(), interval: 0.1,
                                      repeats: true, block: { (timer) in
                    if self.measureTime == 599 { self.buttonTapAction(self.measureDataView.stopButton) }
                    if let data = self.motion.accelerometerData {
                        let x = data.acceleration.x
                        let y = data.acceleration.y
                        let z = data.acceleration.z
                        
                        self.motionXArray.append(x)
                        self.motionYArray.append(y)
                        self.motionZArray.append(z)
             
                        self.setLabelValue(x: x, y: y, z: z)
                        self.measureDataView.accView.getData(x: x, y: y, z: z)
                                                
                        if abs(x) > max || abs(y) > max || abs(z) > max {
                            self.measureDataView.accView.isOverflow = true
                            max *= 1.2
                            self.measureDataView.accView.max = max
                            self.setTextsIndicateLabels(max: max, min: -max)
                        }
                        
                        self.measureDataView.accView.setNeedsDisplay()
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
        measureDataView.gyroView.erase()
        measureDataView.gyroView.drawable = true
        var max = Constants.gyroMax
        measureDataView.gyroView.max = Constants.gyroMax
        setTextsIndicateLabels(max: max, min: -max)
        if motion.isGyroAvailable {
                motion.gyroUpdateInterval = 0.1
                motion.startGyroUpdates()
                self.gyroTimer = Timer(fire: Date(), interval: 0.1,
                                       repeats: true, block: { (timer) in
                    if self.measureTime == 599 { self.buttonTapAction(self.measureDataView.stopButton) }
                    if let data = self.motion.gyroData {
                        let x = data.rotationRate.x
                        let y = data.rotationRate.y
                        let z = data.rotationRate.z
       
                        self.motionXArray.append(x)
                        self.motionYArray.append(y)
                        self.motionZArray.append(z)
                        
                        self.setLabelValue(x: x, y: y, z: z)
                        self.measureDataView.gyroView.getData(x: x, y: y, z: z)
     
                        if abs(x) > max || abs(y) > max || abs(z) > max {
                            self.measureDataView.gyroView.isOverflow = true
                            max *= 1.2
                            self.measureDataView.gyroView.max = max
                            self.setTextsIndicateLabels(max: max, min: -max)
                        }
                        
                        self.measureDataView.gyroView.setNeedsDisplay()
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
        measureDataView.activityIndicator.startAnimating()
        
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
            self.measureDataView.activityIndicator.stopAnimating()
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
                measureDataView.containerView.exchangeSubview(at: 0, withSubviewAt: 1)
                measureDataView.gyroView.isHidden = true
                measureDataView.accView.isHidden = false
                setTextsIndicateLabels(max: Constants.accMax, min: -Constants.accMax)
            } else{
                measureDataView.containerView.exchangeSubview(at: 1, withSubviewAt: 0)
                measureDataView.gyroView.isHidden = false
                measureDataView.accView.isHidden = true
                setTextsIndicateLabels(max: Constants.gyroMax, min: -Constants.gyroMax)
            }
        self.setLabelValue(x: 0.0, y: 0.0, z: 0.0)
    }
    
    @objc func buttonTapAction(_ sender: UIButton) {
        switch sender {
        case measureDataView.measureButton:
            if measureDataView.segmentedControl.selectedSegmentIndex == 0 {
                startAccelerometers()
            } else {
                startGyroscope()
            }
            measureDataView.segmentedControl.isEnabled = false
            measureDataView.saveBarButtonItem.isEnabled = false
            isPlaying = true
        case measureDataView.stopButton:
            if measureDataView.segmentedControl.selectedSegmentIndex == 0 {
                stopMeasuring(accTimer)
            } else {
                stopMeasuring(gyroTimer)
            }
            measureDataView.segmentedControl.isEnabled = true
            measureDataView.saveBarButtonItem.isEnabled = true
            isPlaying = false
        case measureDataView.saveButton:
            saveMeasuredData()
        default:
            return
        }
    }
}




