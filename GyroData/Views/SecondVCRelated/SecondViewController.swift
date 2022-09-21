//
//  SecondViewController.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class SecondViewController: UIViewController, SecondViewControllerRoutable, SecondViewStyling, SceneDismissable {
    // MARK: UI
    var saveButton = UIBarButtonItem()
    var backButton = UIBarButtonItem()
    lazy var segmentView = SecondViewSegementedControlView(viewModel: self.viewModel.segmentViewModel)
    var dummyGraphView = UIView()
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
            segmentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            segmentView.widthAnchor.constraint(equalToConstant: 300),
            segmentView.heightAnchor.constraint(equalToConstant: 30),
            dummyGraphView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 24),
            dummyGraphView.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor),
            dummyGraphView.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor),
            dummyGraphView.heightAnchor.constraint(equalTo: dummyGraphView.widthAnchor),
            controlView.leadingAnchor.constraint(equalTo: segmentView.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: segmentView.trailingAnchor),
            controlView.topAnchor.constraint(equalTo: dummyGraphView.bottomAnchor, constant: 80),
            controlView.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureView() {
        self.view.backgroundColor = .white
        dummyGraphView.backgroundColor = .systemCyan
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
    }
    
    // MARK: Action
    @objc private func didTapSaveButton() {
        viewModel.didTapSaveButton()
    }
    
    @objc private func didTapBackButton() {
        viewModel.didTapBackButton()
    }
}
