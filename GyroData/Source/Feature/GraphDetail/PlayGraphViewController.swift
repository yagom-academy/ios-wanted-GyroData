//
//  PlayGraphViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit

class PlayGraphViewController: UIViewController {
    
    var motionInfo : MotionInfo?
    var timer : Timer?
    var elapsedTime : Double = 0.0
    var isPlaying : Bool = false
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = motionInfo?.date
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Play"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var playView : GraphView = {
        let view = GraphView(id: .play, xPoints: [0.0], yPoints: [0.0], zPoints: [0.0])
        view.backgroundColor = .clear
        view.measuredTime = (motionInfo?.motionX.count) ?? 0
        return view
    }()
    
    let timerLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 30, weight: .heavy)
        lbl.text = "0.0"
        return lbl
    }()
    
    let xLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        return lbl
    }()
    
    let yLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .green
        return lbl
    }()
    
    let zLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .blue
        return lbl
    }()
    
    let plotView : PlotView = {
        let view = PlotView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var playButton : UIButton = {
        let button = UIButton()
        let playImage = UIImage(systemName: "play.fill")
        button.setImage(playImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(touched), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)
        button.configuration = config
        
        return button
    }()
    
    @objc func touched(_ sender:UIButton) {
        isPlaying.toggle()
        if isPlaying {
            
            let stopImage = UIImage(systemName: "stop.fill")
            sender.setImage(stopImage, for: .normal)
            
            playView.erase()
            playView.drawable = true
            
            //MARK: - 타이머 코드 추가
            timer = Timer(timeInterval: 0.1, repeats: true) { (timer) in
                
                let elapsedTime = self.playView.elapsedTime
                self.timerLabel.text = String(format:"%5.1f",Double(elapsedTime) / 10)
                
                if  elapsedTime > (self.motionInfo?.motionX.count ?? 0) - 1{
                    timer.invalidate()
                    let playImage = UIImage(systemName: "play.fill")
                    sender.setImage(playImage, for: .normal)
                }
                
                let (x,y,z) = self.extractMotionInfo(self.motionInfo, at: elapsedTime)
                self.playView.getData(x: x, y: y, z: z)
                self.setLabelValue(x: x, y: y, z: z)
                self.playView.setNeedsDisplay()
            }
            
            if let timer = timer {
                RunLoop.current.add(timer, forMode: .default)
            }
        } else {
            let playImage = UIImage(systemName: "play.fill")
            sender.setImage(playImage, for: .normal)
            timer?.invalidate()
            elapsedTime = 0.0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        addViews()
        setConstraints()
    }
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
    
    func setProperties() {
        self.title = "다시보기"
        self.view.backgroundColor = .systemBackground
    }
    
    func addViews(){
        view.addSubviews(dateLabel, typeLabel, plotView, playView, playButton, timerLabel, xLabel, yLabel, zLabel)
        
        [dateLabel, typeLabel, plotView, playView, playButton, timerLabel, xLabel, yLabel, zLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints(){
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            plotView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plotView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plotView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            plotView.heightAnchor.constraint(equalTo: plotView.widthAnchor),
            playView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            playView.heightAnchor.constraint(equalTo: playView.widthAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 30),
            timerLabel.trailingAnchor.constraint(equalTo: playView.trailingAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            timerLabel.widthAnchor.constraint(equalTo: playView.widthAnchor).constraintWithMultiplier(0.25),
            xLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor).constraintWithMultiplier(0.5),
            yLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor),
            zLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor).constraintWithMultiplier(1.5),
            xLabel.topAnchor.constraint(equalTo: plotView.topAnchor),
            yLabel.topAnchor.constraint(equalTo: plotView.topAnchor),
            zLabel.topAnchor.constraint(equalTo: plotView.topAnchor)
        ])
    }
    
    func setLabelValue(x:Double, y:Double, z:Double){
        xLabel.text = "x:" + String(format:"%.2f",x)
        yLabel.text = "y:" + String(format:"%.2f",y)
        zLabel.text = "z:" + String(format:"%.2f",z)
    }
    
    func extractMotionInfo(_ motionInfo:MotionInfo?, at idx:Int) -> (Double,Double,Double){
        if let motionInfo = motionInfo {
            if motionInfo.motionX.count != 0 && motionInfo.motionY.count != 0 && motionInfo.motionZ.count != 0 {
                return (motionInfo.motionX[idx], motionInfo.motionY[idx], motionInfo.motionZ[idx])
            }
        }
        return (0.0, 0.0, 0.0)
    }
}
