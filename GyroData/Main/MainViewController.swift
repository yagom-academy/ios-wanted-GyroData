//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("Replay VC", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "시작"
        self.view.backgroundColor = .white
        self.testButton.addTarget(self, action: #selector(tap(_:)), for: .touchUpInside)
        self.view.addSubview(testButton)
        
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview() //정중앙에 배치
        }
    }
    
    @objc func tap(_ sender: UIButton) {
        self.navigationController?.pushViewController(ReplayViewController(), animated: true)
    }


}

