//
//  GraphView.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

final class GraphView: UIView {
    let xLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    let yLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    let zLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .green
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    func configureLayout() {
        addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(xLabel)
        labelStackView.addArrangedSubview(yLabel)
        labelStackView.addArrangedSubview(zLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 100)
        ])
    }
    
    private func drawGraphLines(_ rect: CGRect, color: UIColor, dataList: [Double], maximumCount: CGFloat) {
        let mappedDataList = dataList.map { value in
            rect.midY - CGFloat(value) * 5
        }
        let space = rect.width / maximumCount
        let linePath = UIBezierPath()
        var x: CGFloat = 0
        
        color.setStroke()
        linePath.lineWidth = 1
        mappedDataList.forEach({ value in
            let point = CGPoint(x: x, y: value)
            
            if linePath.isEmpty {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
            x += space
        })
        linePath.stroke()
    }
}
