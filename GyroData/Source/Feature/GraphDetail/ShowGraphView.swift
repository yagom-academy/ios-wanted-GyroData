//
//  ShowGraphView.swift
//  GyroData
//
//  Created by 권준상 on 2022/09/27.
//

import UIKit

class ShowGraphView: UIView {
    var motionInfo: MotionInfo?
    
    lazy var reviewView : GraphView = {
        let xPoints = motionInfo?.motionX
        let yPoints = motionInfo?.motionY
        let zPoints = motionInfo?.motionZ
        let view = GraphView(id: .show,
                             xPoints: xPoints ?? [],
                             yPoints: yPoints ?? [],
                             zPoints: zPoints ?? [],
                             max: extractMaxValue((xPoints ?? [])+(yPoints ?? [])+(zPoints ?? [])))

        view.drawable = true
        view.measuredTime = (motionInfo?.motionX.count)!
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = motionInfo?.date
        label.textColor = .systemColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "View"
        label.textColor = .systemColor
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
    
    init(_ motionInfo: MotionInfo) {
        self.motionInfo = motionInfo
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        addViews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        self.addSubviews(dateLabel, typeLabel, plotView, reviewView, xLabel, yLabel, zLabel)
        
        [dateLabel, typeLabel, plotView, reviewView, xLabel, yLabel, zLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints(){
        let safeArea = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            plotView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plotView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plotView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            plotView.heightAnchor.constraint(equalTo: plotView.widthAnchor),
            reviewView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            reviewView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            reviewView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            reviewView.heightAnchor.constraint(equalTo: reviewView.widthAnchor),
            xLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor).constraintWithMultiplier(0.5),
            xLabel.topAnchor.constraint(equalTo: plotView.topAnchor),
            yLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor),
            yLabel.topAnchor.constraint(equalTo: plotView.topAnchor),
            zLabel.centerXAnchor.constraint(equalTo: plotView.centerXAnchor).constraintWithMultiplier(1.5),
            zLabel.topAnchor.constraint(equalTo: plotView.topAnchor)
        ])
    }
    
    func extractMaxValue(_ motion:[Double]) -> Double {
        let positiveMax = motion.max()  ?? 0.0
        let negativeMax = motion.min()  ?? 0.0
        return abs(positiveMax) > abs(negativeMax) ? positiveMax : negativeMax
    }
}
