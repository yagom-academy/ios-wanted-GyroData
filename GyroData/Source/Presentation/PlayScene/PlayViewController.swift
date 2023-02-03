//
//  PlayViewController.swift
//  GyroData
//
//  Created by 이정민 on 2023/02/03.
//

import Foundation
import UIKit

class PlayViewController: UIViewController {
    private let viewModel: PlayViewModel
    private let dateLabel = UILabel(textStyle: .body)
    private let typeLabel = UILabel(textStyle: .title1)
    
    private let labelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let graphView: GraphView = {
        let view = GraphView(interval: 0.1, duration: 60)
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timerLabel = UILabel(textStyle: .title2)
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        
        return button
    }()
    
    init(viewModel: PlayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLabelStackView()
        setupGraphView()
        setupPlayButton()
        setupStopButton()
        setupTimerLabel()
        
        setupBind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        graphView.drawEntireData()
    }
}

extension PlayViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        title = "다시보기"
    }
    
    func setupLabelStackView() {
        let safeArea = view.safeAreaLayoutGuide
        let data = viewModel.entireData
        
        view.addSubview(labelStackView)
        [dateLabel, typeLabel].forEach { labelStackView.addArrangedSubview($0) }
        
        dateLabel.text = data.date.description
        typeLabel.text = "Play"
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
    }
    
    func setupGraphView() {
        view.addSubview(graphView)
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 30),
            graphView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
        
        graphView.playDelegate = self
        graphView.setEntrieData(data: viewModel.fetchSegmentData())
    }
    
    func setupBind() {
        graphView.timeIntervalBind { timeInterval in
            self.timerLabel.text = String(format: "%.2f", timeInterval)
        }
    }
    
    func setupPlayButton() {
        view.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            playButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 44),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor)
        ])
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    func setupStopButton() {
        view.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            stopButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 44),
            stopButton.heightAnchor.constraint(equalTo: stopButton.widthAnchor)
        ])
        
        stopButton.isHidden = true
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    func setupTimerLabel() {
        view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            timerLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
        ])
        
        timerLabel.text = String(format: "%.2f", viewModel.entireData.runTime)
    }
}

extension PlayViewController {
    @objc func playButtonTapped(_ sender: UIButton) {
        graphView.playEntireDataFlow()
        stopButton.isHidden = false
        playButton.isHidden = true
    }
    
    @objc func stopButtonTapped(_ sender: UIButton) {
        graphView.stopEntireDataFlow()
        stopButton.isHidden = true
        playButton.isHidden = false
    }
}

extension PlayViewController: GraphViewPlayDelegate {
    func endPlayingGraphView() {
        stopButton.isHidden = true
        playButton.isHidden = false
    }
}

import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        let viewModel = PlayViewModel(
            entireData:
                MeasureData(
                    xValue: [],
                    yValue: [],
                    zValue: [],
                    runTime: 0,
                    date: Date(),
                    type: .accelerometer
                )
        )
        PlayViewController(viewModel: viewModel).toPreview()
    }
}


#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif


