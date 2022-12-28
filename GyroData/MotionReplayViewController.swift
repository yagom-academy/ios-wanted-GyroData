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
    private var didPlayStarted = false

    init(replayType: ReplayType, motionRecord: MotionRecord) {
        viewModel = MotionReplayViewModel(replayType: replayType, record: motionRecord)
        graphView = GraphView(xScale: CGFloat(motionRecord.coordinates.count))
        graphView.translatesAutoresizingMaskIntoConstraints = false
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
        layout()
        setUpLabelContents()
        setUpGraphViewLayer()
    }

    override func viewDidLayoutSubviews() {
        switch viewModel.replayType {
        case .play:
            if !viewModel.didPlayStarted { playGraphView() }
        case .view:
            showFinishedGraphView()
        }
    }

    private func layout() {
        [dateLabel, typeLabel, graphView].forEach {
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
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }

    private func setUpLabelContents() {
        dateLabel.text = viewModel?.record.startDate.toString()
        typeLabel.text = viewModel?.replayType.name
    }

    private func setUpGraphViewLayer() {
        graphView.layer.borderColor = UIColor.black.cgColor
        graphView.layer.borderWidth = 2
    }

    private func playGraphView() {
        let record = viewModel.record
        viewModel.didPlayStarted = true
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.graphView.drawGraphFor1Hz(layerType: .red, value: record.coordinates[index].x)
            self.graphView.drawGraphFor1Hz(layerType: .green, value: record.coordinates[index].y)
            self.graphView.drawGraphFor1Hz(layerType: .blue, value: record.coordinates[index].z)
            index += 1
            if index >= record.coordinates.count {
                timer.invalidate()
            }
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
