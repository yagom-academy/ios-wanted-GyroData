//  GyroData - DetailViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

class DetailViewController: UIViewController {
    
    private enum Constant {
        static let replayMode = "View"
        static let saveButtonTitle = "저장"
        static let title = "다시보기"
    }
    let detailViewMode: DetailViewMode
    let createdAt: Date
    let detailViewModel: DetailViewModel
    
    init(detailViewMode: DetailViewMode, createdAt: Date) {
        self.detailViewMode = detailViewMode
        self.createdAt = createdAt
        self.detailViewModel = DetailViewModel(date: createdAt)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.text = "2022/08/07 15:13:33"
        
        return label
    }()
    
    private let replayModeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.text = Constant.replayMode
        
        return label
    }()
    
    private let graphView: GraphView = {
        let view = GraphView()
        
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
    }
    
    private func setupNavigation() {
        navigationItem.title = Constant.title
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        [createdAtLabel, replayModeLabel].forEach(labelStackView.addArrangedSubview(_:))
        [labelStackView, graphView].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            
            graphView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 30),
            graphView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            graphView.widthAnchor.constraint(equalTo: labelStackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 1),
        ])
    }
}
