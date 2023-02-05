//
//  MotionDataDetailViewController.swift
//  GyroData
//
//  Created by summercat on 2023/01/31.
//

import UIKit

enum DetailViewType: String {
    case view = "View"
    case play = "Play"
}

final class MotionDataDetailViewController: UIViewController {
    enum Constant {
        enum Namespace {
            static let playButton = "play.fill"
            static let stopButton = "stop.fill"
            static let defaultTimerText = "0.0"
        }
        
        enum Layout {
            static let spacing: CGFloat = 8
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
    
    private let graphView: GraphView = {
        let graphView = GraphView()
        graphView.backgroundColor = .systemBackground
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private let playStopButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: Constant.Namespace.playButton)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.Namespace.defaultTimerText
        label.isHidden = true
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
        configureHierarchy()
        configureLayout()
        setButtonAction()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.onAppear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        graphView.drawGrid()
        viewModel.action(.didAppear(handler: { [weak self] coordinates in
            self?.graphView.drawCompleteGraph(with: coordinates)
        }))
    }
    
    private func configureHierarchy() {
        [viewTypeLabel, graphView, playStopButton, timerLabel]
            .forEach { view.addSubview($0) }
        playStopButton.addSubview(imageView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            viewTypeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            viewTypeLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: viewTypeLabel.bottomAnchor, constant: Constant.Layout.spacing),
            graphView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            playStopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.Layout.spacing),
            playStopButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            playStopButton.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.2),
            playStopButton.heightAnchor.constraint(equalTo: playStopButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.centerYAnchor.constraint(equalTo: playStopButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private func setButtonAction() {
        playStopButton.addAction(
            UIAction { _ in
                self.graphView.resetGraph()
                self.viewModel.action(.playStopButtonTapped(handler: { buttonImage in
                    self.imageView.image = UIImage(systemName: buttonImage)
                })) },
            for: .touchUpInside
        )
    }
    
    private func setNavigationTitle(with text: String) {
        title = text
    }
    
    private func setViewTypeLabelText(with text: String) {
        viewTypeLabel.text = text
    }
    
    private func showPlayStopButtonAndTimerLabel() {
        timerLabel.isHidden = false
        playStopButton.isHidden = false
    }
    
    private func bind() {
        viewModel.bind(
            setNavigationTitle: setNavigationTitle,
            setViewTypeText: setViewTypeLabelText,
            showPlayViewComponents: showPlayStopButtonAndTimerLabel
        )
        viewModel.bind { coordinate, timerText in
            self.graphView.updateGraph(with: coordinate)
            self.timerLabel.text = timerText
        }
        viewModel.bind { coordinates in
            self.graphView.configureAxisRange(coordinates)
        }
    }
}
