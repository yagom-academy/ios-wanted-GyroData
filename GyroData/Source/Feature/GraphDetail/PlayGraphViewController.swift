//
//  PlayGraphViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit

class PlayGraphViewController: UIViewController {
    
    lazy var playGraphView: PlayGraphView = {
        let view = PlayGraphView(motionInfo ?? MotionInfo())
        return view
    }()
    
    var motionInfo : MotionInfo?
    var timer : Timer?
    var playTime : Int = 0
    var isPlaying : Bool = false
    
    override func loadView() {
        self.view = playGraphView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
    }
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
    
    func setProperties() {
        self.title = motionInfo?.measureTime ?? "다시 보기"
        setLabelValue(x: 0.0, y: 0.0, z: 0.0)
        playGraphView.playButton.addTarget(self, action: #selector(touched), for: .touchUpInside)        
    }
    
    func setLabelValue(x:Double, y:Double, z:Double){
        playGraphView.xLabel.text = "x:" + String(format:"%.2f",x)
        playGraphView.yLabel.text = "y:" + String(format:"%.2f",y)
        playGraphView.zLabel.text = "z:" + String(format:"%.2f",z)
    }
    
    func extractMotionInfo(_ motionInfo:MotionInfo?, at idx:Int) -> (Double,Double,Double){
        if let motionInfo = motionInfo {
            if motionInfo.motionX.count != 0 && motionInfo.motionY.count != 0 && motionInfo.motionZ.count != 0 {
                return (motionInfo.motionX[idx], motionInfo.motionY[idx], motionInfo.motionZ[idx])
            }
        }

        timer?.invalidate()

        return (0.0, 0.0, 0.0)
    }

    
    @objc func touched(_ sender:UIButton) {
        isPlaying.toggle()
        if isPlaying {
            
            let stopImage = UIImage(systemName: "stop.fill")
            sender.setImage(stopImage, for: .normal)
            
            playGraphView.playView.erase()
            playGraphView.playView.drawable = true
            
            timer = Timer(timeInterval: 0.1, repeats: true) { (timer) in
                
                self.playGraphView.timerLabel.text = String(format:"%4.1f",Double(self.playTime) / 10.0)
                
                if self.playTime >= (self.motionInfo?.motionX.count ?? 0) {
                    timer.invalidate()
                    let playImage = UIImage(systemName: "play.fill")
                    sender.setImage(playImage, for: .normal)
                    return
                }
                
                let (x,y,z) = self.extractMotionInfo(self.motionInfo, at: self.playTime)
                self.playGraphView.playView.getData(x: x, y: y, z: z)
                self.setLabelValue(x: x, y: y, z: z)
                self.playGraphView.playView.setNeedsDisplay()
                self.playTime += 1
            }
            
            if let timer = timer {
                RunLoop.current.add(timer, forMode: .default)
            }
        } else {
            let playImage = UIImage(systemName: "play.fill")
            sender.setImage(playImage, for: .normal)
            timer?.invalidate()
            playTime = 0
        }
    }
}
