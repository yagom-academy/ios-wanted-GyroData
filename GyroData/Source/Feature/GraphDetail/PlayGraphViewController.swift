//
//  PlayGyroViewController.swift
//  GyroData
//
//  Created by 신동오 on 2022/09/22.
//

import UIKit

class PlayGraphViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "다시보기"
        self.view.backgroundColor = .white
       // print(motionInfo)
        view.addSubview(playView)
        view.addSubview(playBtn)
        playView.translatesAutoresizingMaskIntoConstraints = false
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            playView.heightAnchor.constraint(equalTo: playView.widthAnchor),
            playBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playBtn.topAnchor.constraint(equalTo: playView.bottomAnchor, constant: 30)
        ])
        
    }
    
    var motionInfo : MotionInfo?
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
//    
//    
//    lazy var moveToNextVC : UIButton = {
//        let btn = UIButton(primaryAction: UIAction(handler: {_ in
//        }))
//        btn.setTitle("측정", for: .normal)
//        btn.backgroundColor = .green
//        return btn
//    }()
//    
//    lazy var back : UIButton = {
//        let btn = UIButton(primaryAction: UIAction(handler:{ _ in
//            let presentingVC = self.presentingViewController
//            presentingVC?.dismiss(animated: true)
//        }))
//        var config = UIButton.Configuration.filled()
//        config.image = UIImage(systemName: "checkmark.circle.fill")
//        config.buttonSize = .medium
//        config.cornerStyle = .capsule
//        config.buttonSize = .medium
//        btn.configuration = config
//        return btn
//    }()

//    var timer : Timer?
//
//    var timerLeft = 600
//
//    var isPlaying : Bool = false{
//        didSet{
//            if isPlaying{
//                var idx = 0
//                self.timer = Timer(timeInterval: 0.1, repeats: true){_ in
//                    self.xLabel.text = "x:" + String(format:"%.2f",self.xPoints[idx])
//                    self.yLabel.text = "y:" + String(format:"%.2f",self.yPoints[idx])
//                    self.zLabel.text = "z:" + String(format:"%.2f",self.zPoints[idx])
//                    idx += 1
//                    guard idx < self.xPoints.count - 3 else {
//                        self.timer?.invalidate()
//                        return
//                    }
//                    self.timerLeft -= 1
//                    if self.timerLeft < 0 {
//                        self.timer?.invalidate()
//                        self.timer = nil
//                    }
//                }
//                RunLoop.current.add(self.timer!, forMode: .default)
//            }else{
//                self.timer?.invalidate()
//            }
//        }
//    }
    
    
//    lazy var playBtn : UIButton = {
//        var config = UIButton.Configuration.plain()
//        let btn = UIButton(primaryAction: UIAction(handler: { _ in
//                if self.isPlaying {
//                    self.acc.pauseAnimation()
//                    self.isPlaying.toggle()
//                }else{
//                    self.acc.startGraphDrawing()
//                    self.isPlaying.toggle()
//                }
//            }
//        }))
//        config.image = UIImage(systemName: "play.fill")
//        config.buttonSize = .medium
//        btn.configuration = config
//        return btn
//    }()
    
    var isPlaying : Bool = false
    
    lazy var playBtn : UIButton = {
        let btn = UIButton()
        let img = UIImage(systemName: "play.fill")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(touched), for: .touchUpInside)
        return btn
    }()
    
    @objc func touched(_ sender:UIButton){
        isPlaying.toggle()
        if isPlaying{
            playView.startGraphDrawing()
            let img = UIImage(systemName: "stop.fill")
            sender.setImage(img, for: .normal)
        }else{
            playView.pauseAnimation()
            let img = UIImage(systemName: "play.fill")
            sender.setImage(img, for: .normal)
        }
    }
//    lazy var xLabel : UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .red
//        return lbl
//    }()
//    lazy var yLabel : UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .green
//        return lbl
//    }()
//    lazy var zLabel : UILabel = {
//        let lbl = UILabel()
//        lbl.textColor = .blue
//        return lbl
//    }()
    
    
    
    
    //dumyData
//    var xPoints : [Double]{
//        var arr = [Double]()
//        for _ in 0..<600{
//            arr.append(Double.random(in: -40..<40))
//        }
//        return arr
//    }
//    var yPoints : [Double]{
//        var arr = [Double]()
//        for _ in 0..<600{
//            arr.append(Double.random(in: -40..<40))
//        }
//        return arr
//    }
//    var zPoints : [Double]{
//        var arr = [Double]()
//        for _ in 0..<600{
//            arr.append(Double.random(in: -40..<40))
//        }
//        return arr
//    }
//
    lazy var playView : GraphView = {
        let xPoints = motionInfo!.motionX
        let yPoints = motionInfo!.motionY
        let zPoints = motionInfo!.motionZ
        let view = GraphView(id : "play",xPoints: xPoints, yPoints: yPoints, zPoints: zPoints)
        view.backgroundColor = .clear
        return view
    }()

    

//
//        presentAcc()
//
//        xLabel.text = "x = 10"
//        yLabel.text = "y = 20"
//        zLabel.text = "z = 30"
//
//
    }
    
//    func presentGyro(){
//        removeViews([acc,xLabel,yLabel,zLabel])
//        addViews(to: self.view, reviewView)
//        addViews(to: reviewView, xLabel,yLabel,zLabel)
//        doNotTranslate(reviewView,xLabel,yLabel,zLabel)
//        NSLayoutConstraint.activate([
//            reviewView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            reviewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            reviewView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            reviewView.heightAnchor.constraint(equalTo: reviewView.widthAnchor),
//            xLabel.topAnchor.constraint(equalTo: reviewView.topAnchor),
//            xLabel.centerXAnchor.constraint(equalTo: reviewView.centerXAnchor).constraintWithMultiplier(0.3),
//            yLabel.topAnchor.constraint(equalTo: reviewView.topAnchor),
//            yLabel.centerXAnchor.constraint(equalTo: reviewView.centerXAnchor),
//            zLabel.topAnchor.constraint(equalTo: reviewView.topAnchor),
//            zLabel.centerXAnchor.constraint(equalTo: reviewView.centerXAnchor).constraintWithMultiplier(1.7)
//        ])
//    }
//
//    func presentAcc(){
//        removeViews([reviewView,xLabel,yLabel,zLabel])
//        addViews(to: self.view, acc)
//        addViews(to: acc, xLabel,yLabel,zLabel)
//        doNotTranslate(acc,xLabel,yLabel,zLabel)
//        NSLayoutConstraint.activate([
//            acc.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            acc.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            acc.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
//            acc.heightAnchor.constraint(equalTo: acc.widthAnchor),
//            xLabel.topAnchor.constraint(equalTo: acc.topAnchor),
//            xLabel.centerXAnchor.constraint(equalTo: acc.centerXAnchor).constraintWithMultiplier(0.3),
//            yLabel.topAnchor.constraint(equalTo: acc.topAnchor),
//            yLabel.centerXAnchor.constraint(equalTo: acc.centerXAnchor),
//            zLabel.topAnchor.constraint(equalTo: acc.topAnchor),
//            zLabel.centerXAnchor.constraint(equalTo: acc.centerXAnchor).constraintWithMultiplier(1.7)
//        ])
//    }
//
//    func removeViews(_ views:[UIView]){
//        _ = views.map{$0.removeFromSuperview()}
//    }
//
//    func addViews(to:UIView,_ views:UIView...){
//        views.forEach{to.addSubview($0)}
//    }
//
//    func doNotTranslate(_ views:UIView...){
//        views.forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
//    }
//
//

