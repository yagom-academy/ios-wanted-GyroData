//
//  DetailViewController.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

import UIKit

enum PageType {
    case play
    case view
    
    var description: String {
        switch self {
        case .play:
            return "Play"
        case .view:
            return "View"
        }
    }
}

final class DetailViewController: UIViewController {
    private let detailView: DetailView
    private let detailViewModel: DetailViewModel
    private let graphViewModel: GraphViewModel
    
    init(viewModel: DetailViewModel, graphViewModel: GraphViewModel) {
        self.detailViewModel = viewModel
        self.graphViewModel = graphViewModel
        self.detailView = DetailView(graph: GraphView(viewModel: graphViewModel))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        detailViewModel.fetchData()
    }
    
    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationItem.title = "다시보기"

        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func bind() {
        detailViewModel.bindDate { [weak self] dateString in
            self?.detailView.dateLabel.text = dateString
        }
        detailViewModel.bindPageType { [weak self] pageTypeString in
            self?.detailView.pageTypeLabel.text = pageTypeString
            self?.detailView.configureView(by: pageTypeString)
        }
        detailViewModel.bindGraphData { [weak self] motionMeasures, duration in
            self?.graphViewModel.setMeasures(motionMeasures, for: duration)
        }
        
    }
    
    
}
