//
//  SecondViewController.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class SecondViewController: UIViewController, SecondViewControllerRoutable {
    
    lazy var segmentView: SecondViewSegementedControlView = SecondViewSegementedControlView(viewModel: self.viewModel.segmentViewModel)
    var viewModel: SecondModel
    
    init(viewModel: SecondModel) {
        self.viewModel = viewModel
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SecondViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        view.addSubview(segmentView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            segmentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 100)
        ]
    }
    
    func configureView() {
        self.view.backgroundColor = .orange
    }
    
    func bind() {
        
    }
}
