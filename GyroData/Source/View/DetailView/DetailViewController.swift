//
//  DetailViewController.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

import UIKit

extension DateFormatter {
    static let measuredDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return dateFormatter
    }()
}

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
    private let detailView = DetailView()
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
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
        viewModel.convertModelData()
    }
    
    private func setupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationItem.title = "다시보기"

        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func bind() {
        viewModel.bindDate { [weak self] dateString in
            self?.detailView.dateLabel.text = dateString
        }
        viewModel.bindPageType { [weak self] pageTypeString in
            self?.detailView.pageTypeLabel.text = pageTypeString
        }
        viewModel.bindGraphData { [weak self] axisX, axisY, axisZ in
            
        }
    }
    
    
    
//    private func setGraph() {
//        let padding: CGFloat = 100
//
//        let frame = CGRect(
//            x: 0,
//            y: 0,
//            width: self.view.frame.width - padding,
//            height: self.view.frame.height - padding
//        )
//        let view = LineGraphView( // 그래프 뷰
//            frame: frame,
//            values: [20, 10, 30, 20, 50, 100, 10, 10]
//        )
//
//        view.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
//        self.view.addSubview(view)
//        graphView = view
//    }
}
