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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let graphView = GraphView()
    private let playStopButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: Constant.Namespace.playButton),
            for: .normal
        )
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let timerLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.0"
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
        view.backgroundColor = .systemBackground
        configureViews()
        setButtonAction()
        viewModel.bind(
            navigationTitle: setNavigationTitle,
            viewTypeText: setViewTypeLabelText,
            showButton: showPlayPauseButton
        )
        viewModel.bind { coordinate, timerText in
            // draw
            self.timerLabel.text = timerText
        }
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
        playStopButton.isHidden = false
    }
    
    private func configureViews() {
        [viewTypeLabel, graphView, playStopButton, timerLabel]
            .forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            viewTypeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            viewTypeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        ])
        
        graphView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: viewTypeLabel.bottomAnchor, constant: Constant.Layout.spacing),
            graphView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playStopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.Layout.spacing),
            playStopButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.Layout.spacing),
            timerLabel.leadingAnchor.constraint(equalTo: playStopButton.trailingAnchor, constant: Constant.Layout.spacing),
            timerLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor, constant: -Constant.Layout.spacing)
        ])
    }
    
    private func setButtonAction() {
        playStopButton.addAction(
            UIAction { _ in
                self.viewModel.action(.buttonTapped(handler: { buttonImage in
                    self.playStopButton.setImage(
                        UIImage(systemName: buttonImage),
                        for: .normal
                )
                })) },
            for: .touchUpInside
        )
    }
}
