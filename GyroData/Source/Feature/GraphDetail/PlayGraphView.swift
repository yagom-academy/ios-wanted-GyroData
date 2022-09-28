//
//  PlayGraphView.swift
//  GyroData
//
//  Created by 권준상 on 2022/09/27.
//

import UIKit

class PlayGraphView: UIView {
    var motionInfo: MotionInfo?
    
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
        label.text = "Play"
        label.textColor = .systemColor
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var playView : GraphView = {
        let xPoints = motionInfo?.motionX
        let yPoints = motionInfo?.motionY
        let zPoints = motionInfo?.motionZ
        let view = GraphView(id: .play,
                             xPoints: [0.0],
                             yPoints: [0.0],
                             zPoints: [0.0],
                             max: extractMaxValue((xPoints ?? [])+(yPoints ?? [])+(zPoints ?? [])))
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
        button.tintColor = .systemColor
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)
        button.configuration = config
        
        return button
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
        self.addSubviews(dateLabel, typeLabel, plotView, playView, playButton, timerLabel, xLabel, yLabel, zLabel)
        
        [dateLabel, typeLabel, plotView, playView, playButton, timerLabel, xLabel, yLabel, zLabel].forEach {
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
            playView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            playView.heightAnchor.constraint(equalTo: playView.widthAnchor),
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
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
    
    func extractMaxValue(_ motion:[Double]) -> Double {
        let positiveMax = motion.max()  ?? 0.0
        let negativeMax = motion.min()  ?? 0.0
        return abs(positiveMax) > abs(negativeMax) ? positiveMax : negativeMax
    }
}
