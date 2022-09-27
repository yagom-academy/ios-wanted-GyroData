//
//  ShowGraphViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit

class ShowGraphViewController: UIViewController {

    var motionInfo : MotionInfo?
    
    lazy var reviewView : Graph = {
        let xPoints = motionInfo!.motionX
        let yPoints = motionInfo!.motionY
        let zPoints = motionInfo!.motionZ
        let view = Graph(id: .show, xPoints: xPoints, yPoints: yPoints, zPoints: zPoints)

        view.drawable = true
        view.measuredTime = (motionInfo?.motionX.count)!
        view.backgroundColor = .clear
        return view
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
    
    let plot : PlotView = {
       let view = PlotView()
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        addViews()
        setConstraints()
        setLabelValue()
    }
    
    func setProperties() {
        self.title = "다시보기"
        self.view.backgroundColor = .white
    }
    
    func addViews(){
        view.addSubviews(plot, reviewView, xLabel, yLabel, zLabel)
        
        [plot, reviewView, xLabel, yLabel, zLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            plot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plot.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plot.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            plot.heightAnchor.constraint(equalTo: plot.widthAnchor),
            reviewView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reviewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            reviewView.heightAnchor.constraint(equalTo: reviewView.widthAnchor),
            xLabel.centerXAnchor.constraint(equalTo: plot.centerXAnchor).constraintWithMultiplier(0.5),
            xLabel.topAnchor.constraint(equalTo: plot.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: plot.centerXAnchor),
            yLabel.topAnchor.constraint(equalTo: plot.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: plot.centerXAnchor).constraintWithMultiplier(1.5),
            zLabel.topAnchor.constraint(equalTo: plot.topAnchor)
        ])
    }
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
    
    func extractMaxValue(_ motion:[Double]) -> String {
        let positiveMax = motion.max()!
        let negativeMax = motion.min()!
        return String(format:"%.2f", abs(positiveMax) > abs(negativeMax) ? positiveMax : negativeMax )
    }

    func setLabelValue(){
        xLabel.text = "x:" + extractMaxValue(motionInfo!.motionX)
        yLabel.text = "y:" + extractMaxValue(motionInfo!.motionY)
        zLabel.text = "z:" + extractMaxValue(motionInfo!.motionZ)
    }

}
