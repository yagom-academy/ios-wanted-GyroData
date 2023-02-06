//
//  ReplayViewController.swift
//  GyroData
//
//  Created by Baem, Dragon on 2023/01/31.
//

import UIKit

final class ReplayViewController: UIViewController {
    
    // MARK: Enumerations
    
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
        button.setImage(UIImage(systemName: NameSpace.playButtonImageName), for: .normal)
        button.addTarget(nil, action: #selector(tapToggleButton), for: .touchUpInside)
        return button
    }()
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = NameSpace.initialTimerLabelText
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initializer
    
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
    
    // MARK: Private Methods
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        navigationItem.title = NameSpace.navigationItemTitle
    }
    
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(dateLabel)
        titleStackView.addArrangedSubview(titleLabel)
    }
    
    private func setUpTopStackView() {
        topStackView.addArrangedSubview(titleStackView)
        topStackView.addArrangedSubview(graphView)
        setupTitleStackView()
    }
    
    private func setUpBottomStackView() {
        bottomStackView.addArrangedSubview(playToggleButton)
        bottomStackView.addArrangedSubview(timerLabel)
    }
    
    private func configureLayout() {
        let margin = view.layoutMarginsGuide
        
        setUpTopStackView()
        setUpBottomStackView()
        
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
            replayData.forEach { motionData in
                graphView.motionDatas = motionData
            }
            bottomStackView.removeFromSuperview()
        case .play:
            titleLabel.text = mode.rawValue
        }
        
        if let formatDate = motionData.date {
            let format = DateFormatter()
            
            format.dateFormat = NameSpace.dateFormat
            
            dateLabel.text = format.string(from: formatDate)
        }
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
            playToggleButton.setImage(UIImage(systemName: NameSpace.stopButtonImageName), for: .normal)
            timerData = Int.init()
            graphView.clearData()
            state = .play
            
        case .play:
            timer.invalidate()
            playToggleButton.setImage(UIImage(systemName: NameSpace.playButtonImageName), for: .normal)
            state = .stop
        }
    }
    
    @objc private func timerCallBack() {
        if replayData.count <= timerData { return }
        graphView.motionDatas = replayData[timerData]
        timerData += 1
        timerLabel.text = String(Double(timerData) / 10 )
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let navigationItemTitle = "다시보기"
    static let playButtonImageName = "play.fill"
    static let stopButtonImageName = "stop.fill"
    static let dateFormat = "yyyy/MM/dd HH:mm:ss"
    static let initialTimerLabelText = "0.00"
}
