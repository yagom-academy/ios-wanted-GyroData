//
//  ReplayView.swift
//  GyroData
//
//  Created by seohyeon park on 2022/12/26.
//

import UIKit

enum ReplayViewType {
    case view
    case play
    
    var name: String {
        switch self {
        case .view:
            return "View"
        case .play:
            return "Play"
        }
    }
}

class ReplayView: UIView {
    let measurementTime: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022/09/07 15:10:11"
        return label
    }()
    
    let pageTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View"
        return label
    }()
    
    let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
            self.addSubview(measurementTime)
            self.addSubview(pageTypeLabel)
            self.addSubview(graphView)

            NSLayoutConstraint.activate([
                measurementTime.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30),
                measurementTime.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30),
                measurementTime.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),

                pageTypeLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30),
                pageTypeLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30),
                pageTypeLabel.topAnchor.constraint(equalTo: measurementTime.bottomAnchor, constant: 5),
                
                graphView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 30),
                graphView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -30),
                graphView.topAnchor.constraint(equalTo: pageTypeLabel.bottomAnchor, constant: 30),
                graphView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -300)
            ])
        }
}
