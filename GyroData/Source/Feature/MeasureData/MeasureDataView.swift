//
//  MeasureDataView.swift
//  GyroData
//
//  Created by 권준상 on 2022/09/27.
//

import UIKit

class MeasureDataView: UIView {
    
    lazy var segmentedControl: UISegmentedControl = {
      let control = UISegmentedControl(items: ["Acc", "Gyro"])
        control.selectedSegmentTintColor = .systemBlue
        control.backgroundColor = .secondarySystemBackground
        control.selectedSegmentIndex = 0
      return control
    }()
    
    lazy var measureButton : UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    lazy var stopButton : UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
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
    
    let plotView : PlotView = {
       let view = PlotView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var gyroView : GraphView = {
        let view = GraphView(id: .measure, xPoints: [0.0], yPoints: [0.0], zPoints: [0.0], max: Constants.gyroMax)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var accView : GraphView = {
        let view = GraphView(id: .measure, xPoints: [0.0], yPoints: [0.0], zPoints: [0.0], max: Constants.accMax)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemBlue
        activityIndicator.layer.zPosition = 1
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        addSubviews(plotView, containerView, segmentedControl, measureButton, stopButton)
        containerView.addSubviews(accView, gyroView, xLabel, yLabel, zLabel, maxLabel, minLabel, activityIndicator)
        
        [plotView, containerView, segmentedControl, measureButton, stopButton, accView, gyroView, xLabel, yLabel, zLabel, maxLabel, minLabel, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            plotView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plotView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            plotView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            plotView.heightAnchor.constraint(equalTo: plotView.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20),
            segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            measureButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            measureButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            stopButton.topAnchor.constraint(equalTo: measureButton.bottomAnchor, constant: 20),
            stopButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
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
}
