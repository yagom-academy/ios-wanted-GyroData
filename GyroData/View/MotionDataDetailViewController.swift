//
//  MotionDataDetailViewController.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import UIKit

final class MotionDataDetailViewController: UIViewController {
    enum Constant {
        enum Namespace {
            static let playButton = "play.fill"
            static let stopButton = "stop.fill"
        }
        
        enum Layout {
            static let spacing = CGFloat(8)
        }
    }
    
    private let viewModel: MotionDataDetailViewModel
    private let viewTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let graphView = GraphView()
    private let playStopButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: Constant.Namespace.playButton),
            for: .normal
        )
        button.setImage(
            UIImage(systemName: Constant.Namespace.stopButton),
            for: .selected
        )
        button.isHidden = true
        return button
    }()

    private let timerLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    init(viewModel: MotionDataDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        viewModel.bind(
            navigationTitle: setNavigationTitle,
            viewTypeText: setViewTypeLabelText,
            showButton: showPlayPauseButton
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.onAppear)
    }
    
    private func setNavigationTitle(with text: String) {
        title = text
    }
    
    private func setViewTypeLabelText(with text: String) {
        viewTypeLabel.text = text
    }
    
    private func showPlayPauseButton() {
        playStopButton.isHidden = true
    }
    
    private func configureViews() {
        [viewTypeLabel, graphView, playStopButton, timerLabel]
            .forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            viewTypeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            viewTypeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            graphView.topAnchor.constraint(equalTo: viewTypeLabel.bottomAnchor, constant: Constant.Layout.spacing),
            graphView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            playStopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.Layout.spacing),
            playStopButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.Layout.spacing),
            timerLabel.leadingAnchor.constraint(equalTo: playStopButton.trailingAnchor, constant: Constant.Layout.spacing),
            timerLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor, constant: -Constant.Layout.spacing)
        ])
    }
}
