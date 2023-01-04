//
//  GraphRecordViewController.swift
//  GyroData
//
//  Created by unchain, Ellen J, yeton on 2022/12/28.
//

import UIKit
import SwiftUI
import Combine

final class GraphRecordViewController: UIViewController {
    private var graphRecordViewModel: GraphRecordViewModel
    private var cancelable = Set<AnyCancellable>()
    
    init(graphRecordviewModel: GraphRecordViewModel) {
        self.graphRecordViewModel = graphRecordviewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(graphRecordViewModel: GraphRecordViewModel, isViewMode: Bool) {
        self.init(graphRecordviewModel: graphRecordViewModel)
        if isViewMode {
            self.viewNameLabel.text = "View"
            self.playButton.isHidden = true
            self.timerLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphRecordViewModel.input.onViewDidLoad()
        setup()
        setupUI()
        bind()
    }
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.text = "X: 0.0"
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.text = "Y: 0.0"
        label.textColor = .green
        label.font = .preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.text = "Z: 0.0"
        label.textColor = .blue
        label.font = .preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        return stack
    }()
    
    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022/10/20 15:10:11"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    private lazy var viewNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Play"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var graphView: UIView = HostingViewController(model: graphRecordViewModel.environmentGraphModel).view
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor(r: 101, g: 159, b: 247,a: 1)
        button.addTarget(self, action: #selector(tappedPlayButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "stop.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.tintColor = UIColor(r: 101, g: 159, b: 247,a: 1)
        button.isHidden = true
        button.addTarget(self, action: #selector(tappedStopButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00.0"
        label.contentCompressionResistancePriority(for: .horizontal)
        label.textColor = .white
        label.font = label.font.withSize(25)
        return label
    }()
    
    private func setup() {
        self.view.backgroundColor = UIColor(r: 39, g: 40, b: 46, a: 1)
        view.addSubviews(
            dateLabel,
            viewNameLabel,
            graphView,
            playButton,
            stopButton,
            timerLabel,
            locationStackView
        )
        
        locationStackView.addArrangedSubview(xLabel)
        locationStackView.addArrangedSubview(yLabel)
        locationStackView.addArrangedSubview(zLabel)
    }
    
    private func setupUI() {
        graphView.backgroundColor = .white
        graphView.layer.cornerRadius = 10
        
        // MARK: - locationStackView
        NSLayoutConstraint.activate([locationStackView.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 10),
                                     locationStackView.leadingAnchor.constraint(equalTo: graphView.leadingAnchor, constant: 5),
                                     locationStackView.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -5),
                                     locationStackView.heightAnchor.constraint(equalToConstant: 50)
                                    ])
        
        // MARK: - dateLabel
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: viewNameLabel.topAnchor, constant: -5),
            dateLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
        
        // MARK: - viewNameLabel
        NSLayoutConstraint.activate([
            viewNameLabel.bottomAnchor.constraint(equalTo: graphView.topAnchor, constant: -20),
            viewNameLabel.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            viewNameLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
        
        // MARK: - graphView
        NSLayoutConstraint.activate([
            graphView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            graphView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            graphView.widthAnchor.constraint(equalToConstant: 300),
            graphView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // MARK: - playButton
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 35),
            playButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // MARK: - pauseButton
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 35),
            stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 30),
            stopButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // MARK: - timerLabel
        NSLayoutConstraint.activate([
            timerLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
    }
}

extension GraphRecordViewController {
    private func bind() {        
        graphRecordViewModel.output.secondPublisher
            .sink { [weak self] second in
                guard let self = self else { return }
                self.timerLabel.text = second
            }
            .store(in: &cancelable)
        
        graphRecordViewModel.output.playCompletePublisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.stopButton.isHidden = true
                self.playButton.isHidden = false
            }
            .store(in: &cancelable)
        
        graphRecordViewModel.analyzeModelPublisher
            .sink { [weak self] (x: Double, y: Double, z: Double) in
                guard let self = self else { return }
                self.xLabel.text = "X:" + String(format: "%.1f", x)
                self.yLabel.text = "y:" + String(format: "%.1f",y)
                self.zLabel.text = "z:" + String(format: "%.1f",z)
            }
            .store(in: &cancelable)
    }
    
    @objc private func tappedPlayButton() {
        graphRecordViewModel.input.tappedPlayButton()
        self.stopButton.isHidden = false
        self.playButton.isHidden = true
    }
    
    @objc private func tappedStopButton() {
        graphRecordViewModel.input.tappedStopButton()
        self.stopButton.isHidden = true
        self.playButton.isHidden = false
    }
}
