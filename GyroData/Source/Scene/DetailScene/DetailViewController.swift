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
        view.backgroundColor = .systemBackground
        bind()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBar()
        configureButtonAction()
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
        detailViewModel.bindPageType { [weak self] pageTypeString, isViewPage in
            self?.detailView.pageTypeLabel.text = pageTypeString
            self?.detailView.configureView(isViewPage)
        }
        detailViewModel.bindGraphData { [weak self] motionMeasures, duration in
//            self?.graphViewModel.setMeasures(motionMeasures, for: duration)
        }
        detailViewModel.bindTimer { [weak self] imageName in
            let image = UIImage(systemName: imageName)
            self?.detailView.playButton.setImage(image, for: .normal)
        }
        detailViewModel.bindDuration { [weak self] duration in
            self?.detailView.timerLabel.text = String(format: "%.1f", duration)
        }
    }
}

extension DetailViewController {
    private func configureButtonAction() {
        detailView.playButton.addTarget(self, action: #selector(touchUpPlayButton), for: .touchUpInside)
    }
    
    @objc private func touchUpPlayButton() {
        detailViewModel.touchButton()
    }
}
