//
//  SecondViewController.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class SecondViewController: UIViewController, SecondViewControllerRoutable, SecondViewStyling {
    // MARK: UI
    var saveButton = UIBarButtonItem()
    var backButton = UIBarButtonItem()
    lazy var segmentView = SecondViewSegementedControlView(viewModel: self.viewModel.segmentViewModel)
    var dummyGraphView = TestPathGraphView()
    var controlView = SecondControlView()
    
    // MARK: Properties
    var viewModel: SecondModel
    
    // MARK: Init
    init(viewModel: SecondModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycles
    override func loadView() {
        initViewHierarchy()
        configureView()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: Presentable
extension SecondViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        view.addSubview(segmentView)
        view.addSubview(dummyGraphView)
        view.addSubview(controlView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        dummyGraphView.translatesAutoresizingMaskIntoConstraints = false
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            segmentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            segmentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            segmentView.heightAnchor.constraint(equalToConstant: 42),
            dummyGraphView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 16),
            dummyGraphView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dummyGraphView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dummyGraphView.heightAnchor.constraint(equalTo: dummyGraphView.widthAnchor),
            controlView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            controlView.topAnchor.constraint(equalTo: dummyGraphView.bottomAnchor, constant: 48)
        ]
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        
        navigationItem.title = "측정하기"
        
        saveButton.addStyles(style: saveButtonStyling)
        saveButton.target = self
        saveButton.action = #selector(didTapSaveButton)
        
        backButton.addStyles(style: backButtonStyling)
        backButton.target = self
        backButton.action = #selector(didTapBackButton)
    }
    
    func bind() {
        viewModel.routeSubject = { [weak self] scene in
            self?.route(to: scene)
        }
        
        controlView.testClosure = { [weak self] in
            let randomX = CGFloat.random(in: -10...10)
            let randomY = CGFloat.random(in: -10...10)
            let randomZ = CGFloat.random(in: -10...10)
            let tempData = ValueInfo(xValue: randomX, yValue: randomY, zValue: randomZ)
            self?.dummyGraphView.didReceiveData(tempData)
        }
    }
    
    // MARK: Action
    @objc private func didTapSaveButton() {
        viewModel.didTapSaveButton()
    }
    
    @objc private func didTapBackButton() {
        viewModel.didTapBackButton()
    }
}
