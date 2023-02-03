//
//  ReplayMotionViewController.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import UIKit

class ReplayMotionViewController: UIViewController {

    private var replayMotionViewModel: ReplayMotionViewModel?
    var timer: Timer!
    var watchStatus: WatchStatus = .start
    var replayTime: Double!
    var playingTime = 0.0

    init(replayMotionViewModel: ReplayMotionViewModel?) {
        self.replayMotionViewModel = replayMotionViewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()

        label.text = "test date"
        return label
    }()

    let typeLabel: UILabel = {
        let label = UILabel()

        label.text = "test type"
        return label
    }()

    let graphView: GraphView = {
        let view = GraphView()

        return view
    }()

    let playButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(didTappedStartButton), for: .touchUpInside)

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "play.fill", withConfiguration: largeConfig)

        btn.setImage(largeBoldDoc, for: .normal)

        return btn
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "text time"
        return label
    }()

    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playButton, timeLabel])
        stackView.alignment = .leading
        return stackView
    }()

    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, typeLabel, graphView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
    }

    // MARK: - setUp UI
    func configureUI() {
        configureHierarchy()
        configureLayout()
        configureNavigation()

        setUpUIData()
    }

    func configureHierarchy() {
        graphView.dataSource = self
        view.addSubview(containerStackView)
    }

    func configureLayout() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 16),

            typeLabel.heightAnchor.constraint(equalToConstant: 36),

            graphView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 0.9),

            buttonStackView.heightAnchor.constraint(equalToConstant: 50),

            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
//            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureNavigation() {
        self.navigationController?.title = "다시 보기"
    }

    // MARK: - binding Data
    func setUpUIData() {
        let cellData = replayMotionViewModel?.bindCellData()
        
        dateLabel.text = cellData?.0.date.description

        replayTime = cellData?.0.time
        typeLabel.text = cellData?.1.rawValue

        switch cellData?.1 {
        case .play:
            drawnGraph()
        case .view:
            buttonStackView.isHidden = false
        case .none: break
        }
    }

    func drawnGraph() {
        
    }
}
// MARK: - setUP Timer
extension ReplayMotionViewController {

    @objc
    func didTappedStartButton(_ sender: UIButton) {

        timeLabel.text = String(format: "%.1f", playingTime)

        switch self.watchStatus {
        case .start:
            self.watchStatus = .stop
            self.timer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(timeUp),
                                              userInfo: nil,
                                              repeats: true)

            let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium)
            let largeBoldDoc = UIImage(systemName: "stop.fill", withConfiguration: largeConfig)

            playButton.setImage(largeBoldDoc, for: .normal)

        case .stop:
            playingTime = 0
            self.watchStatus = .start
            timer?.invalidate()
            timer = nil

            let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium)
            let largeBoldDoc = UIImage(systemName: "play.fill", withConfiguration: largeConfig)

            playButton.setImage(largeBoldDoc, for: .normal)
        }

    }
    @objc
    private func timeUp() {
        playingTime += 0.1
        timeLabel.text = String(format: "%.1f", playingTime)

        if playingTime > replayTime {
            timer?.invalidate()
            timer = nil
        }

        //drawing graph
    }
}

extension ReplayMotionViewController: GraphViewDataSource {
    func dataList(graphView: GraphView) -> [[Double]] {
        return [[1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3],
                [1, 2, 3]]
    }

    func maximumXValueCount(graphView: GraphView) -> CGFloat {
        return 20
    }

    func numberOfLines(graphView: GraphView) -> Int {
        return 3
    }
}

enum WatchStatus {
    case start
    case stop
}
