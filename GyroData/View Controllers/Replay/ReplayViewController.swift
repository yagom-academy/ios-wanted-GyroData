//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 박호현 on 2022/09/24.
//

import UIKit

class ReplayViewController: UIViewController {
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = self.recordDate?.dateString ?? ""
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.text = type?.typeString ?? ReplayType.view.typeString
        return label
    }()
    
    private var graphView: GraphView = {
        let width = UIScreen.main.bounds.width - 32
        let height = width
        let view = GraphView(frame: CGRect(x: .zero, y: .zero, width: width, height: height))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var playButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray
        button.isHidden = (self.type == .view)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray
        button.isHidden = true
        return button
    }()
    
    private lazy var playTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.text = "0.0"
        label.isHidden = (self.type == .view)
        return label
    }()
    
    var type: ReplayType? = nil
    var recordDate: Date? = nil
    var isPlaying = false
    private let fileManager = FileManagerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureViews()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if type == .view {
            readMotionDataWithView()
        }
    }
    
    private func readMotionDataWithView() {
        DispatchQueue.global().async {
            if let date = self.recordDate {
                self.fileManager.read(with: date) { result in
                    switch result {
                    case .success(let success):
                        DispatchQueue.main.async {
                            self.graphView.storedData = success.items
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }
    
    var motionItems: [MotionDataItem]?
    private func readMotionDataWithPlay() {
        DispatchQueue.global().async {
            if self.motionItems != nil {
                self.drawGraphViewWithPlay()
            } else {
                if let date = self.recordDate {
                    self.fileManager.read(with: date) { result in
                        switch result {
                        case .success(let success):
                            self.motionItems = success.items
                            self.drawGraphViewWithPlay()
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
            }
        }
    }
    
    private func drawGraphViewWithPlay() {
        if let motionItems = self.motionItems {
            for item in motionItems {
                if isPlaying == false { break }
                DispatchQueue.main.async {
                    self.playTimeLabel.text = item.tick.description
                    self.graphView.realtimeData.append(item)
                }
                usleep(100000)
            }
            DispatchQueue.main.async {
                self.playButton.isHidden = false
                self.stopButton.isHidden = true
                self.isPlaying = false
            }
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(dateLabel)
        view.addSubview(typeLabel)
        view.addSubview(playTimeLabel)
        view.addSubview(graphView)
        view.addSubview(playButton)
        view.addSubview(stopButton)
    }
    
    private func configureNavigation() {
        navigationItem.title = "다시보기"
    }
    
    private func configureLayout() {
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            graphView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            
            playButton.widthAnchor.constraint(equalToConstant: 44),
            playButton.heightAnchor.constraint(equalToConstant: 44),
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stopButton.widthAnchor.constraint(equalToConstant: 44),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            stopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playTimeLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50),
            playTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func didTapPlayButton() {
        playButton.isHidden = true
        stopButton.isHidden = false
        isPlaying = true
        
        self.graphView.realtimeData.removeAll()
        readMotionDataWithPlay()
    }
    
    @objc func didTapStopButton() {
        stopButton.isHidden = true
        playButton.isHidden = false
        isPlaying = false
    }
}
