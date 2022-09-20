//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class FirstViewController: UIViewController, FirstViewStyling {

    var measureButton: UIButton = UIButton() //test용도, 프로젝트 진행에 따라 적당한 위치로 이동
    lazy var contentView: FirstListView = FirstListView(viewModel: self.model.contentViewModel)
    
    var model: FirstModel
    
    init(viewModel: FirstModel) {
        self.model = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        initViewHierarchy()
        configureView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}



extension FirstViewController: Presentable {
    func initViewHierarchy() {
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
        
        measureButton.addStyles(style: measureButtonStyling)
    }
    
    func bind() {
        
    }
}
