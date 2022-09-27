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
    lazy var graphView = GraphView(viewModel: self.viewModel.graphViewModel)
    lazy var gridView = GridView()
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
        view.addSubview(gridView)
        view.addSubview(graphView)
        view.addSubview(controlView)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        gridView.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            infoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ]
        
        constraints += [
            gridView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 32),
            gridView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            gridView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            gridView.heightAnchor.constraint(equalTo: gridView.widthAnchor),
        ]
        
        constraints += [
            graphView.topAnchor.constraint(equalTo: infoView.bottomAnchor, constant: 32),
            graphView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
        ]
        
        constraints += [
            controlView.topAnchor.constraint(equalTo: graphView.bottomAnchor),
            controlView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
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
        
        viewModel.viewTypeSource = { [weak self] viewType in
            self?.controlView.isHidden = viewType == .view
        }
    }
    
    // MARK: Action
    @objc private func didTapBackButton() {
        viewModel.didTapBackButton()
    }
}
