//
//  MeasureView.swift
//  GyroData
//
//  Created by 신동원 on 2022/09/21.
//
import UIKit
import SnapKit

class MeasureView: UIView {
    
    let splashLogo = UIImageView()
    let splashText = UIImageView()
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Acc","Gyro"])
        control.setTitle("Acc", forSegmentAt: 0)
        control.setTitle("Gyro", forSegmentAt: 1)
        control.layer.borderWidth = 1
        control.selectedSegmentTintColor = UIColor(named: "light_navy")
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
    }
    
    func setupConstraints() {
        
        segmentControl.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide)
            //make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}
