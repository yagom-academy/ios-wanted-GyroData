//
//  ReplayViewController.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

final class ReplayViewController: UIViewController {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let playStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let graphView: UIView = {
        let graphView = UIView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()

    private let playButton = UIButton()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let replayViewModel: ReplayViewModel
    private var timer: Timer?
    private var timerIndex = 0

    init(replayViewModel: ReplayViewModel) {
        self.replayViewModel = replayViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        replayViewModel.load()
        configureNavigationBar()
        configureView()
        configureLayout()
    }

    private func configureNavigationBar() {
        navigationItem.title = "다시 보기"
    }

    private func configureView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(graphView)
        mainStackView.addArrangedSubview(dateLabel)
        mainStackView.addArrangedSubview(titleLabel)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func bind() {
        replayViewModel.motionMode.bind { motion in
            guard let motion = motion else { return }
            switch motion {
            case .view: break
                self?.configureViewMode()
            case .play: break
                self?.configurePlayMode()
            }
        }

        replayViewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            // 얼럿 띄우기
        }

        replayViewModel.graphData.bind { [weak self] data in
            guard let data = data else { return }
            self?.dateLabel.text = data.gyroInformation.date.convertToString()
        }
    }

    private func configureViewMode() {
        configureUIToViewMode()
        drawGraph()
    }

    private func configurePlayMode() {
        configureUIToPlayMode()
        configureButton()
    }

}

extension ReplayViewController {
    private func configureUIToViewMode() {
        titleLabel.text = "View"
    }

    private func drawGraph() {
        guard let data = replayViewModel.graphData.value else { return }

        let motionData = zip(data.x, zip(data.y, data.z))
        let minCount = min(data.x.count, data.y.count, data.z.count)
        let width = CGFloat((view.bounds.width - 60.0) / Double(minCount))

        // TODO: 그래프 뷰 구현하고 나서 해야할 거 같다
    }

    private func configureUIToPlayMode() {
        mainStackView.addArrangedSubview(playStackView)
        playStackView.addArrangedSubview(playButton)
        playStackView.addArrangedSubview(timerLabel)

        titleLabel.text = "Play"

        timerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
    }

    private func configureButton() {
        if playButton.isSelected {
            startDrawing()
        } else {
            stopDrawing()
        }
    }

    private func startDrawing() {
        guard let data = replayViewModel.graphData.value else { return }

        let xData = data.x
        let yData = data.y
        let zData = data.z
        let timeOut = min(data.x.count, data.y.count, data.z.count)
        var timeCount = Double.zero

        if timerIndex == timeOut {
            // TODO: 그래픽 뷰 초기화
            timerIndex = 0
        }

        timer = Timer(timeInterval: 0.1,
                      repeats: true,
                      block: { [weak self] timer in
            guard var timerIndex = self?.timerIndex else { return }

            if timerIndex == timeOut {
                timer.invalidate()
                self?.timer = nil
                self?.playButton.isSelected = false
                return
            }

            let graphData = [xData[timerIndex], yData[timerIndex], zData[timerIndex]]
            // TODO: 그래픽 뷰에 add

            timerIndex += 1
            timeCount += 0.1
            self?.timerLabel.text = String(format: "%.1f", timeCount)
        })
    }

    private func stopDrawing() {
        guard let currentTimer = timer else { return }
        currentTimer.invalidate()
    }
}
