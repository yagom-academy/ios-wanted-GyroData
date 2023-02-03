//
//  MeasureResultViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import UIKit

class MeasureResultViewController: UIViewController {
    var motionData: MotionEntity
    var coordinates: [Coordinate] = []
    var pageType: MeasureViewType
    var timer: Timer?
     
    var second: Double = 0.0 {
        didSet {
            timeLabel.text = "\(second)"
        }
    }
    
    var graphView: GraphView = {
        let view = GraphView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().formatted("yyyy/MM/dd HH:mm:ss")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: imageConfig), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        button.setImage(UIImage(systemName: "stop.fill", withConfiguration: imageConfig), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(data: MotionEntity, pageType: MeasureViewType) {
        self.motionData = data
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureData()
        configureLayout()
        configureAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureGraphView()
    }
    
    func configureAction() {
        playButton.addTarget(self, action: #selector(playDrawGraph), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopDrawGraph), for: .touchUpInside)
    }
    
    func configureGraphView() {
        graphView.configureData()
        if pageType == .view {
            indicatorView.startAnimating()
            delay(3) {
                self.coordinates.forEach { coordinate in
                    self.graphView.drawLine(x: coordinate.x, y: coordinate.y, z: coordinate.z)
                }
            }
            indicatorView.stopAnimating()
        }
    }
    
    func configureData() {
        guard let fileId = motionData.id,
              let fileData = FileManager.default.load(path: fileId.uuidString) else { return }
        
        coordinates = fileData
        pageLabel.text = pageType.rawValue
        dateLabel.text = "\(motionData.date!.formatted("yyyy/MM/dd HH:mm:ss"))"
        
        stopButton.isHidden = true
        if pageType == .view {
            playButton.isHidden = false
            stopButton.isHidden = true
        }
    }
    
    @objc func playDrawGraph() {
        var currentIndex: Int = 0
        pageType = .play
        pageLabel.text = pageType.rawValue
        graphView.configureData()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            if currentIndex >= self.coordinates.count {
                self.stopDrawGraph()
                return
            }
            
            self.graphView.drawLine(x: self.coordinates[currentIndex].x,
                                    y: self.coordinates[currentIndex].y,
                                    z: self.coordinates[currentIndex].z)
            currentIndex += 1
            self.second = Double(currentIndex) / 10
        })
        stopButton.isHidden = false
        playButton.isHidden = true
    }
    
    @objc func stopDrawGraph() {
        timer?.invalidate()
        stopButton.isHidden = true
        playButton.isHidden = false
    }
    
    func configureLayout() {
        view.addSubview(dateLabel)
        view.addSubview(pageLabel)
        view.addSubview(graphView)
        view.addSubview(buttonStackView)
        view.addSubview(timeLabel)
        view.addSubview(indicatorView)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(stopButton)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            pageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            pageLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            graphView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 20),
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            buttonStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            buttonStackView.heightAnchor.constraint(equalToConstant: 80),
            
            timeLabel.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: buttonStackView.trailingAnchor)
        ])
    }
    
    func delay(_ delay: Double, closure: @escaping () -> ()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
