//
//  DetailViewController.swift
//  GyroData
//
//  Created by Tak on 2022/12/30.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let recordDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "View"
        return label
    }()
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        button.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
        return button
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "다시보기"
    }
    
    @objc private func playButtonTapped(_ sender: UIButton) {
        self.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
    }
    
    private func setLayout() {
        view.addSubview(recordDateLabel)
        view.addSubview(stateLabel)
        view.addSubview(playButton)
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            recordDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recordDateLabel.bottomAnchor.constraint(equalTo: stateLabel.topAnchor, constant: -10)
        ])
        NSLayoutConstraint.activate([
            stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            stateLabel.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -20)
        ])
        // playButton, timerLabel layout 추가하기
    }
}
