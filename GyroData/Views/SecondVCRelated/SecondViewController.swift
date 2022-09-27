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
    lazy var graphView = GraphView(viewModel: self.viewModel.graphViewModel)
    lazy var gridView = GridView()
    lazy var controlView = SecondControlView(viewModel: self.viewModel.controlViewModel)
    var indicatorView = SecondHoveringIndicatorView()
    
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
}

// MARK: Presentable
extension SecondViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        view.addSubview(segmentView)
        view.addSubview(gridView)
        view.addSubview(graphView)
        view.addSubview(controlView)
        view.addSubview(indicatorView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        gridView.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        controlView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            segmentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            segmentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            segmentView.heightAnchor.constraint(equalToConstant: 42),
        ]
        
        constraints += [
            gridView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 16),
            gridView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            gridView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            gridView.heightAnchor.constraint(equalTo: gridView.widthAnchor),
        ]
        
        constraints += [
            graphView.topAnchor.constraint(equalTo: segmentView.bottomAnchor, constant: 16),
            graphView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
        ]
        constraints += [
            controlView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            controlView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 48),
        ]
        constraints += [
            indicatorView.topAnchor.constraint(equalTo: self.view.topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
        
        indicatorView.isHidden = true
    }
    
    func bind() {
        viewModel.routeSubject = { [weak self] scene in
            self?.route(to: scene)
        }
        
        viewModel.isMeasuringSource = { [weak self] isMeasuring in
            self?.saveButton.isEnabled = !isMeasuring
        }
        
        viewModel.isLoadingSource = { [weak self] isLoading in
            self?.indicatorView.isHidden = !isLoading
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
