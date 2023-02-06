//
//  PlayViewController.swift
//  GyroData
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class PlayViewController: UIViewController {

    // MARK: - Enum Type
    enum Constant {
        static let smallSpacing: CGFloat = 8
        static let middleSpacing: CGFloat = 20
    }

    enum viewType: String {
        case play = "Play"
        case view = "View"
    }

    // MARK: - Property
    private let playType: viewType
    private let metaData: TransitionMetaData
    private var transitionData: Transition = Transition(values: [])
    private var playTime: Double = 0.0
    private var isStopDrawing: Bool = true
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let viewTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(for: .largeTitle, weight: .bold)
        return label
    }()
    
    private let graphView: GraphView = {
        let graphView = GraphView(frame: .zero)
        graphView.backgroundColor = .systemBackground
        return graphView
    }()
    
    private let controlButton: UIButton = {
        let button = UIButton()
        
        let configure = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40), scale: .large)
        
        let playImage = UIImage(systemName: "play.fill", withConfiguration: configure)
        button.setImage(playImage, for: .normal)
        
        let pauseImage = UIImage(systemName: "pause.fill", withConfiguration: configure)
        button.setImage(pauseImage, for: .selected)
        
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()

    // MARK: - LifeCycle
    
    init(viewType: PlayViewController.viewType, metaData: TransitionMetaData) {
        self.playType = viewType
        self.metaData = metaData
        super.init(nibName: nil, bundle: nil)
        graphView.delegate = self
        
        SystemFileManager().readData(fileName: metaData.jsonName, type: Transition.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.transitionData = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setButtonActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if playType == .view {
            graphView.drawPlayGraph(ticks: transitionData.values, viewType: playType)
        }
    }
}

// MARK: - Button Method
private extension PlayViewController {
    func setButtonActions() {
        controlButton.addTarget(
            self,
            action: #selector(didTapControlButton),
            for: .touchUpInside
        )
    }
}

// MARK: - Objc Method
private extension PlayViewController {
    @objc func didTapControlButton() {
        controlButton.isSelected.toggle()
        
        if controlButton.isSelected == false {
            graphView.resetGraph()
        } else {
            graphView.drawPlayGraph(ticks: transitionData.values, viewType: playType)
        }
    }
}

// MARK: - GraphDelegate
extension PlayViewController: GraphDelegate {
    var isCheckFinish: Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                controlButton.isSelected.toggle()
                graphView.resetGraph()
            }
        }
    }

    func checkTime(time: Double) {
        timeLabel.text = String(format: "%.1f", time)
    }
}

// MARK: - UIConfiguration
private extension PlayViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        setAdditionalSafeArea()
        
        setNavigationBar()
        
        addBaseChildComponents()
        addPlayChildComponents()
        
        setComponentsValues()
        setUpBaseLayout()
    }
    
    func addBaseChildComponents() {
        [
            dateLabel,
            viewTypeLabel,
            graphView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if playType == .play {
            addPlayChildComponents()
        }
    }
    
    func addPlayChildComponents() {
        if playType == .play {
            [
                controlButton,
                timeLabel
            ].forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
    
    func setAdditionalSafeArea() {
        let padding: CGFloat = 10
        additionalSafeAreaInsets.left += padding
        additionalSafeAreaInsets.right += padding
        additionalSafeAreaInsets.top += padding
        additionalSafeAreaInsets.bottom += padding
    }
    
    func setUpBaseLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            viewTypeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constant.smallSpacing),
            viewTypeLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            viewTypeLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            graphView.topAnchor.constraint(equalTo: viewTypeLabel.bottomAnchor, constant: Constant.middleSpacing),
            graphView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constant.middleSpacing),
            graphView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constant.middleSpacing),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
        
        if playType == .play {
            setControlLayout()
        }
    }
    
    func setControlLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            controlButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            controlButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.middleSpacing),
            timeLabel.centerYAnchor.constraint(equalTo: controlButton.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: controlButton.trailingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func setComponentsValues() {
        dateLabel.text = metaData.saveDate
        viewTypeLabel.text = self.playType.rawValue
        
        if playType == .play {
            timeLabel.text = playTime.description
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "다시보기"
    }
}
