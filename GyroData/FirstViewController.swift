//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class FirstViewController: UIViewController, FirstViewStyling {

    var measureButton: UIButton = UIButton() //test용도, 프로젝트 진행에 따라 적당한 위치로 이동
    
    override func loadView() {
        initViewHierachy()
        configureView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}



extension FirstViewController: Presentable {
    func initViewHierachy() {
        self.view = UIView()
        
        self.view.addSubview(measureButton)
        
        measureButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            measureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            measureButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        measureButton.addStyle(style: measureButtonStyling)
    }
    
    func bind() {
        
    }
}
