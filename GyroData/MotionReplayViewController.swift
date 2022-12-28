//
//  MotionReplayViewController.swift
//  GyroData
//
//  Created by 천수현 on 2022/12/28.
//

import UIKit

final class MotionReplayViewController: UIViewController {
    private var viewModel: MotionReplayViewModel?
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let graphView: GraphView = {
        let graph = GraphView()
        graph.translatesAutoresizingMaskIntoConstraints = false
        return graph
    }()

    init(replayType: ReplayType, motionRecord: MotionRecord) {
        viewModel = MotionReplayViewModel(replayType: replayType, record: motionRecord)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        setUpLabelContents()
    }

    private func layout() {
        [dateLabel, typeLabel, graphView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            typeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            graphView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }

    private func setUpLabelContents() {
        dateLabel.text = viewModel?.record.startDate.description
        typeLabel.text = viewModel?.replayType.name
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
