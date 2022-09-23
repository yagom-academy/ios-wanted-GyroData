//
//  ThirdViewController.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit

class ThirdViewController: UIViewController, ThirdViewControllerRoutable, ThirdViewStyling {
    // MARK: UI
    lazy var infoView = ThirdInfoView(viewModel: self.viewModel.infoViewModel)
    var backButton = UIBarButtonItem()
    var dummyGraphView = TestPathGraphView()
    lazy var controlView = ThirdControlView(viewModel: self.viewModel.controlViewModel)
    
    // MARK: Properties
    var viewModel: ThirdModel
    
    // MARK: Init
    init(viewModel: ThirdModel) {
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
}

extension ThirdViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        view.addSubview(infoView)
        view.addSubview(dummyGraphView)
        view.addSubview(controlView)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        dummyGraphView.translatesAutoresizingMaskIntoConstraints = false
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            infoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            dummyGraphView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 32),
            dummyGraphView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dummyGraphView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dummyGraphView.heightAnchor.constraint(equalTo: dummyGraphView.widthAnchor),
            controlView.topAnchor.constraint(equalTo: dummyGraphView.bottomAnchor),
            controlView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configureView() {
        self.view.backgroundColor = .systemBackground
        navigationItem.title = "다시보기"
        backButton.addStyles(style: backButtonStyling)
        backButton.target = self
        backButton.action = #selector(didTapBackButton)
    }
    
    func bind() {
        viewModel.routeSubject = { [weak self] scene in
            self?.route(to: scene)
        }
        
        viewModel.viewTypeDidChanged = { [weak self] viewType in
            self?.controlView.isHidden = viewType == .view
        }
    }
    
    // MARK: Action
    @objc private func didTapBackButton() {
        viewModel.didTapBackButton()
    }
}
