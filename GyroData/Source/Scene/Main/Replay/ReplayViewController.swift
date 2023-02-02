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
    
    private enum State {
        case stop
        case play
    }
    
    // MARK: Private Properties
    
    private let mode: Mode
    private let motionData: Motion
    private var state = State.stop
    private var timer = Timer()
    private var timerData = Int.init()
    private var replayData = [MotionData]()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
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
    
    init(mode: Mode, motionData: Motion) {
        self.mode = mode
        self.motionData = motionData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureLayout()
        fetchRecodedData()
    }
    
    // MARK: Action Methods
    
    @objc private func tapToggleButton() {
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
    
    @objc private func timerCallBack() {
        if replayData.count <= timerData { return }
        graphView.motionDatas = replayData[timerData]
        timerData += 1
        timerLabel.text = String(Double(timerData) / 10 )
    }
    
    // MARK: Private Methods
    
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
     
    private func fetchRecodedData() {
        guard let data = motionData.jsonData?.data(using: .utf8) else { return }
        
        do {
            replayData = try JSONDecoder().decode([MotionData].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        graphView.changeGraphXSize(graphXSize: motionData.runningTime)
        configureMode()
    }
    
    private func configureMode() {
        switch mode {
        case .view:
            titleLabel.text = mode.rawValue
            replayData.forEach { motiondata in
                graphView.motionDatas = motiondata
            }
            bottomStackView.removeFromSuperview()
        case .play:
            titleLabel.text = mode.rawValue
        }
        dateLabel.text = motionData.date?.description
    }
}
