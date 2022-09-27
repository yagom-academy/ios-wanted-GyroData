//
//  ShowGraphViewController.swift
//  TestGyroData
//
//  Created by 엄철찬 on 2022/09/25.
//

import UIKit

class ShowGraphViewController: UIViewController {

    var motionInfo : MotionInfo?
    
    lazy var reviewView : GraphView = {
        let xPoints = motionInfo?.motionX
        let yPoints = motionInfo?.motionY
        let zPoints = motionInfo?.motionZ
        let view = GraphView(id: .show, xPoints: xPoints ?? [], yPoints: yPoints ?? [], zPoints: zPoints ?? [])

        view.drawable = true
        view.measuredTime = (motionInfo?.motionX.count)!
        view.backgroundColor = .clear
        return view
    }()
    
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
        label.text = "View"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
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
        view.addSubviews(dateLabel, typeLabel, plotView, reviewView, xLabel, yLabel, zLabel)
        
        [dateLabel, typeLabel, plotView, reviewView, xLabel, yLabel, zLabel].forEach {
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
            reviewView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reviewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            reviewView.heightAnchor.constraint(equalTo: reviewView.widthAnchor),
            xLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor).constraintWithMultiplier(0.5),
            xLabel.topAnchor.constraint(equalTo: plotView.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor),
            yLabel.topAnchor.constraint(equalTo: plotView.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor).constraintWithMultiplier(1.5),
            zLabel.topAnchor.constraint(equalTo: plotView.topAnchor)
        ])
    }
    
    func setMotionInfo(_ motionInfo:MotionInfo){
        self.motionInfo = motionInfo
    }
    
    func extractMaxValue(_ motion:[Double]) -> String {
        let positiveMax = motion.max() ?? 0.0
        let negativeMax = motion.min() ?? 0.0
        return String(format:"%.2f", abs(positiveMax) > abs(negativeMax) ? positiveMax : negativeMax )
    }

    func setLabelValue(){
        xLabel.text = "x:" + extractMaxValue(motionInfo!.motionX)
        yLabel.text = "y:" + extractMaxValue(motionInfo!.motionY)
        zLabel.text = "z:" + extractMaxValue(motionInfo!.motionZ)
    }

}
