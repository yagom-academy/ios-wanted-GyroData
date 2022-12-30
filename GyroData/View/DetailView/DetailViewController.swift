//
//  DetailViewController.swift
//  GyroData
//
//  Created by minsson on 2022/12/29.
//

import UIKit

enum DetailType: String {
    case view = "View"
    case play = "Play"
}

final class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private let viewModel: DetailViewModel
    
    init(data: MeasuredData,type: DetailType) {
        viewModel = DetailViewModel(data: data, type: type)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        setupNavigationBar()
        setupButton()
        setupView()
    }
    
    func viewWillAppear() {
        self.detailView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
        
    func setupView() {
        detailView.setupMode(with: viewModel)
    }
}

extension DetailViewController {
    @objc func playButtonDidTapped() {
        if detailView.playButton.image(for: .normal) == UIImage(systemName: "play.fill") && viewModel.model.measuredTime != 0.0 {
            viewModel.resetGraphView()
            detailView.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            viewModel.startTimer { timerCount in
                self.detailView.timerLabel.text = timerCount
                if timerCount == self.viewModel.model.measuredTime.description {
                    self.detailView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                }
            }
        } else if detailView.playButton.image(for: .normal) == UIImage(systemName: "play.fill") {
            detailView.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            viewModel.startTimer { timerCount in
                self.detailView.timerLabel.text = timerCount
                if timerCount == self.viewModel.model.measuredTime.description {
                    self.detailView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                }
            }
        } else if detailView.playButton.image(for: .normal) == UIImage(systemName: "stop.fill") {
            viewModel.stopTimer {
                self.detailView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                viewModel.resetGraphView()
            }
        }
    }
}

private extension DetailViewController {
    func setupNavigationBar() {
        navigationItem.title = "다시보기"
    }
    
    func setupButton() {
        detailView.playButton.addTarget(
            self,
            action: #selector(playButtonDidTapped),
            for: .touchUpInside
        )
    }
}
