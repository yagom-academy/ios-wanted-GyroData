//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

class FirstViewController: UIViewController, FirstViewStyling, FirstViewControllerRoutable {
    // MARK: UI
    lazy var contentView: FirstListView = FirstListView(viewModel: self.model.contentViewModel)
    
    // MARK: Properties
    var model: FirstModel
    
    // MARK: Init
    init(viewModel: FirstModel) {
        self.model = viewModel
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
        // Do any additional setup after loading the view.
    }
}


// MARK: Presentable
extension FirstViewController: Presentable {
    func initViewHierarchy() {
        self.view = UIView()
        
        self.view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        constraint += [
            contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "측정", image: nil, target: self, action: #selector(didTapMesaureButton))
    }
    
    func bind() {
        model.routeSubject = { [weak self] sceneCategory in
            guard let self = self else { return }
            self.route(to: sceneCategory)
        }
        model.populateData()
    }
    
    // MARK: Actions
    @objc private func didTapMesaureButton() {
        model.didTapMeasureButton()
    }
}
