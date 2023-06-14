//
//  DetailViewController.swift
//  GyroData
//
//  Created by 리지 on 2023/06/14.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    private var pageType: PageType
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private lazy var pageTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = pageType.description
        return label
    }()
    
    private let graphView: GraphView = {
        let view = GraphView()
        view.backgroundColor = .white
        let lineWidth: CGFloat = 3
        view.layer.borderWidth = lineWidth
        
        return view
    }()
    
    init(pageType: PageType, viewModel: DetailViewModel) {
        self.pageType = pageType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bind()
    }
    
    private func bind() {
        viewModel.$currentData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.dateLabel.text = self?.viewModel.date
                
                guard let id = data?.id,
                      let data = self?.viewModel.fetchData(by: id),
                      let threeAxisValue = data.threeAxisValue else { return }
                
                self?.graphView.drawGraph(with: threeAxisValue)
            }
            .store(in: &cancellables)
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpUI()
    }
    
    private func setUpNavigationBar() {
        let title = "다시보기"
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setUpUI() {
        view.addSubview(labelStackView)
        view.addSubview(graphView)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(pageTypeLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        let leading: CGFloat = 30
        let trailing: CGFloat = -30
        let bottom: CGFloat = -300
        let graphViewTop: CGFloat = 10
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: trailing),
            
            graphView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: graphViewTop),
            graphView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            graphView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: bottom),
            graphView.widthAnchor.constraint(equalTo: graphView.heightAnchor)
        ])
    }
}
