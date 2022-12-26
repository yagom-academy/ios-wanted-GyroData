//
//  GraphView.swift
//  GyroData
//
//  Created by 정재근 on 2022/12/26.
//

import UIKit

class GraphView: UIView {
    private lazy var xLabel: UILabel = {
        let label = UILabel()
        label.text = "x - 1234"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var yLabel: UILabel = {
        let label = UILabel()
        label.text = "y - 1234"
        label.textColor = .green
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var zLabel: UILabel = {
        let label = UILabel()
        label.text = "z - 1234"
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            xLabel, yLabel, zLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        return stackView
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initalSetting()
    }
    
    private func initalSetting() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        stackViewConstraints()
        setBackgroundLayer()
    }
    
    private func stackViewConstraints() {
        self.addSubview(hStackView)
        self.hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.hStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            self.hStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            self.hStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func setBackgroundLayer() {
        let x = self.frame.width / 7
        let y = self.frame.height / 7
        var currentX = x
        var currentY = y
        let path = UIBezierPath()
        for _ in 0...6 {
            path.move(to: CGPoint(x: currentX, y: 0))
            path.addLine(to: CGPoint(x: currentX, y: self.frame.height))
            path.move(to: CGPoint(x: 0, y: currentY))
            path.addLine(to: CGPoint(x: self.frame.width, y: currentY))
            currentX += x
            currentY += y
        }
        
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = path.lineWidth
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(layer)
    }
}
