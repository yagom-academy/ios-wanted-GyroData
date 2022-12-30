//
//  MotionReplayViewController.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import UIKit

final class MotionReplayViewController: UIViewController {
    private var viewModel: MotionReplayViewModel!
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private var graphView: GraphView
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 80), forImageIn: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 80), forImageIn: .selected)
        button.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private var timer = Timer()

    init(replayType: ReplayType, motionRecord: MotionRecord) {
        viewModel = MotionReplayViewModel(replayType: replayType, id: motionRecord.id)
        graphView = GraphView(xScale: CGFloat(motionRecord.coordinates.count))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        graphView = GraphView()
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNavigationBar()
        layout()
        setUpLabelContents()
        setUpGraphViewLayer()
    }

    override func viewDidLayoutSubviews() {
        viewModel.fetchMotionData { [weak self] in
            guard let self = self else { return }
            if self.viewModel.replayType == .view && !self.viewModel.isDrawingGraphView {
                self.viewModel.isDrawingGraphView = true
                self.showFinishedGraphView()
            }
        }
    }

    private func setUpNavigationBar() {
        navigationItem.title = "다시보기"
        navigationItem.backButtonTitle = ""
    }

    private func layout() {
        [dateLabel, typeLabel, graphView, playButton, timerLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            graphView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 100),
            timerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            timerLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20)
        ])

        if viewModel.replayType == .view {
            playButton.isHidden = true
            timerLabel.isHidden = true
        }
    }

    private func setUpLabelContents() {
        dateLabel.text = viewModel?.record?.startDate.toString()
        typeLabel.text = viewModel?.replayType.name
    }

    private func setUpGraphViewLayer() {
        graphView.layer.borderColor = UIColor.black.cgColor
        graphView.layer.borderWidth = 2
    }

    private func playGraphView() {
        graphView.reset()
        guard let record = viewModel.record else { return }
        viewModel.isDrawingGraphView = true

        var index = 0
        var time: Double = 0

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            self?.graphView.drawGraphFor1Hz(layerType: .red, value: record.coordinates[index].x)
            self?.graphView.drawGraphFor1Hz(layerType: .green, value: record.coordinates[index].y)
            self?.graphView.drawGraphFor1Hz(layerType: .blue, value: record.coordinates[index].z)
            index += 1
            time += 0.1
            if index >= record.coordinates.count {
                timer.invalidate()
                self?.playButton.isSelected = true
                self?.viewModel.isDrawingGraphView = false
            }
            self?.timerLabel.text = "\(String(format:"%.1f", time))"
        }
    }

    private func showFinishedGraphView() {
        guard let record = viewModel?.record else { return }
        record.coordinates.forEach { coordinate in
            self.graphView.drawGraphFor1Hz(layerType: .red, value: coordinate.x)
            self.graphView.drawGraphFor1Hz(layerType: .green, value: coordinate.y)
            self.graphView.drawGraphFor1Hz(layerType: .blue, value: coordinate.z)
        }
    }

    @objc
    private func playButtonTapped(_ sender: UIButton) {
        if viewModel.playButtonState == .play && viewModel.record != nil {
            viewModel.playButtonState = .stop
            playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            playGraphView()
        } else {
            viewModel.playButtonState = .play
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer.invalidate()
        }
    }
}

fileprivate extension ReplayType {
    var name: String {
        switch self {
        case .view:
            return "View"
        case .play:
            return "Play"
        }
    }
}

fileprivate extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
