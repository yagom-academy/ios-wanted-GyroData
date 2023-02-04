//  GyroData - DetailViewController.swift
//  Created by zhilly, woong on 2023/01/31

import UIKit

class DetailViewController: UIViewController {
    
    private enum Constant {
        static let saveButtonTitle = "저장"
        static let title = "다시보기"
    }
    
    let detailViewMode: DetailViewMode
    let createdAt: Date
    let detailViewModel: DetailViewModel
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        
        return label
    }()
    
    private let replayModeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        
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
    
    private let playButton: UIButton = {
        let button = UIButton()
        
        button.isHidden = true
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        
        button.isHidden = true
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let measurementTimeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "30.1"
        label.isHidden = true
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupButtons()
        setupContent()
        setupToMode()
        setupBind()
    }
    
    private func setupNavigation() {
        navigationItem.title = Constant.title
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        [createdAtLabel, replayModeLabel].forEach(labelStackView.addArrangedSubview(_:))
        [labelStackView, graphView, playButton, stopButton, measurementTimeLabel].forEach(view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            
            graphView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 30),
            graphView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            graphView.widthAnchor.constraint(equalTo: labelStackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 1),
            
            playButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            playButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.2),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
            
            stopButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            stopButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.2),
            stopButton.heightAnchor.constraint(equalTo: stopButton.widthAnchor),
            
            measurementTimeLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            measurementTimeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 30)
        ])
    }
    
    private func setupContent() {
        createdAtLabel.text = DateFormatter.convertToDisplayString(date: self.createdAt)
        replayModeLabel.text = self.detailViewMode.description
    }
    
    private func setupToMode() {
        switch detailViewMode {
        case .view:
            let sensorData = detailViewModel.model.value.sensorData
            self.graphView.layoutIfNeeded()
            self.graphView.drawGraph(data: sensorData)
            self.graphView.configure(xPoint: sensorData.x.last,
                                     yPoint: sensorData.y.last,
                                     zPoint: sensorData.z.last)
        case .play:
            self.playButton.isHidden = false
            self.measurementTimeLabel.isHidden = false
        }
    }
    
    private func setupButtons() {
        let playAction = UIAction { _ in
            self.playButton.isHidden = true
            self.stopButton.isHidden = false
            self.tappedPlayButton()
        }
        playButton.addAction(playAction, for: .touchUpInside)
        
        let stopAction = UIAction { _ in
            self.playButton.isHidden = false
            self.stopButton.isHidden = true
            self.tappedStopButton()
        }
        stopButton.addAction(stopAction, for: .touchUpInside)
    }
    
    private func setupBind() {
        detailViewModel.runtime.bind { runtime in
            self.measurementTimeLabel.text = "\(String(format: "%.1f", runtime))"
            
            if runtime >= self.detailViewModel.model.value.runtime {
                self.playButton.isHidden = false
                self.stopButton.isHidden = true
            }
        }
    }
    
    private func tappedPlayButton() {
        self.graphView.resetView()
        detailViewModel.reset()
        detailViewModel.startDraw { x, y, z in
            self.graphView.drawLine(xPoint: x, yPoint: y, zPoint: z)
            self.graphView.configure(xPoint: x, yPoint: y, zPoint: z)
        }
    }
    
    private func tappedStopButton() {
        detailViewModel.stopDraw()
    }
}
