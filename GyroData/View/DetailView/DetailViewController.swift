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
    private var currenType: DetailType?
    private let detailView = DetailView()
    private var myData: MeasuredData?
    private var timer: Timer?
    private var timerNum: Double = 0.0
    
    init(data: MeasuredData,type: DetailType) {
        super.init(nibName: nil, bundle: nil)
        detailView.setupMode(data: data, type: type)
        myData = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        setupNavigationBar()
        setupButton()
    }
}

extension DetailViewController {
    @objc func playButtonDidTapped() {
        if detailView.playButton.image(for: .normal) == UIImage(systemName: "play.fill") {
            detailView.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self ] _ in
                
                guard let self = self else {
                    return
                }
                
                self.timerNum += 0.1
                
                self.detailView.timerLabel.text = self.timerNum.timeDecimal().description
                
                if self.timerNum.timeDecimal() == self.myData?.measuredTime {
                    self.stopTimer()
                    self.timerNum = 0
                }
            })
        } else {
            stopTimer()
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
    
    func stopTimer() {
        detailView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        timer?.invalidate()
    }
}
