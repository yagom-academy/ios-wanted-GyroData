//
//  MeasureView.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/21.
//
import UIKit
import SnapKit

extension UIButton {
    func setCustom() {
        self.setTitleColor(UIColor.systemBlue, for: .normal)
        self.setTitleColor(UIColor.systemGray, for: .highlighted)
    }
}

class MeasureView: UIView {
    
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc","Gyro"])
        control.setTitle("Acc", forSegmentAt: 0)
        control.setTitle("Gyro", forSegmentAt: 1)
        control.layer.borderWidth = 1
        control.selectedSegmentTintColor = UIColor(named: "light_navy")
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
//    let lineChartView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .green
//        return view
//    }()
    
    var lineChartView: UIView!
    
    let measureButton: UIButton = {
        let button = UIButton()
        button.setTitle("측정", for: .normal)
        button.setCustom()
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("정지", for: .normal)
        button.setCustom()
        button.isEnabled = false
        return button
    }()
    //MARK: TEST CODE1
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("테스트", for: .normal)
        button.setCustom()
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        backgroundColor = .white
        addSubview(segmentControl)
        lineChartView = GraphView()
        //lineChartView.backgroundColor = .gray
        lineChartView.layer.borderWidth = 1
        addSubview(lineChartView)
        addSubview(measureButton)
        addSubview(stopButton)
        //MARK: TEST CODE2
        addSubview(testButton)
    }
    
    func setupConstraints() {
        
        segmentControl.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
        
        lineChartView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.height.equalTo(lineChartView.snp.width)
        }
        
        measureButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(lineChartView.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        
        stopButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(measureButton.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        testButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(stopButton.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
    }
}
