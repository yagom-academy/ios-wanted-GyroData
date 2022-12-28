//
//  MeasureViewController.swift
//  GyroData
//
//  Created by Tak on 2022/12/28.
//

import UIKit

class MeasureViewController: UIViewController {
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MeasureViewController"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testLabel)
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
