//
//  ReplayViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit

final class ReplayViewController: UIViewController {
    
    enum Mode: String {
        case view = "View"
        case play = "Play"
    }
    
    enum State {
        case stop
        case play
    }
    let mode: Mode
    var state = State.stop
    var timer = Timer()
    var timerData = Int.init()
//        let replayData = [MotionDataModel]()
    
    // mokData
    let replayData = [MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.05),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -10, y: 2, z: 0.5),
                      MotionData(x: 1, y: 2, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5),
                      MotionData(x: 1, y: 20, z: -0.5),
                      MotionData(x: -1, y: 2, z: 0.5)]
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = Date().description //삭제
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "View" //삭제
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let graphView = GraphView()
    private let playToggleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.addTarget(nil, action: #selector(tapToggleButton), for: .touchUpInside)
        return button
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let titleStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.spacing = 10
        return stackview
    }()
    private let topStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 20
        return stackview
    }()
    private let bottomStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        configureMode()
    }
    
    func configureMode() {
        switch mode {
        case .view:
            titleLabel.text = mode.rawValue
            graphView.totalData(data: replayData)
            bottomStackView.removeFromSuperview()
        case .play:
            titleLabel.text = mode.rawValue
        }
    }
    
    @objc func tapToggleButton() {
        switch state {
        case .stop:
            timer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(timerCallBack),
                userInfo: nil,
                repeats: true
            )
            playToggleButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            timerData = Int.init()
            graphView.clear()
            state = .play
            
        case .play:
            timer.invalidate()
            playToggleButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            state = .stop
        }
    }
    
    @objc func timerCallBack() {
        if replayData.count <= timerData { return }
        graphView.motionDatas = replayData[timerData]
        timerData += 1
        timerLabel.text = String(Double(timerData) / 10 )
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        navigationItem.title = "다시보기"
    }
    
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(dateLabel)
        titleStackView.addArrangedSubview(titleLabel)
    }
    
    private func setupTopStackView() {
        topStackView.addArrangedSubview(titleStackView)
        topStackView.addArrangedSubview(graphView)
        setupTitleStackView()
    }
    
    private func setupBottomStakcView() {
        bottomStackView.addArrangedSubview(playToggleButton)
        bottomStackView.addArrangedSubview(timerLabel)
    }
    
    private func configureLayout() {
        let margin = view.layoutMarginsGuide
        
        setupTopStackView()
        setupBottomStakcView()
        
        view.addSubview(topStackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            graphView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,multiplier: 0.4),
            
            topStackView.topAnchor.constraint(equalTo: margin.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            playToggleButton.heightAnchor.constraint(equalToConstant: margin.layoutFrame.size.width * 0.1),
            playToggleButton.widthAnchor.constraint(equalTo: playToggleButton.heightAnchor),
            
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(
                equalTo: topStackView.leadingAnchor,
                constant: margin.layoutFrame.size.width * 0.4
            ),
            bottomStackView.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
    }
}
