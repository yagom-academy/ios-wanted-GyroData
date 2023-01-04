//
//  MeasurementReplayViewController.swift
//  GyroData
//
//  Created by 백곰, 바드 on 2022/12/26.
//

import UIKit

final class MeasurementReplayViewController: UIViewController {
    
    // MARK: Properties
    
    private let playType: PlayType
    private var timer: Timer?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022/09/07 15:01:05"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let viewTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let gridView = GridView()
    
    private let graphView = GraphView(
        graphType: .play,
        xPoints: MockModel.xPoints,
        yPoints: MockModel.yPoints,
        zPoints: MockModel.zPoints
    )
    
    private let playButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(systemName: "play.fill")
        button.setPreferredSymbolConfiguration(.init(pointSize: 48), forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(playImage, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let playTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00.0"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
           graphView.frame = CGRect(
            x: gridView.frame.minX + 2,
            y: gridView.frame.minY,
            width: gridView.frame.width,
            height: gridView.frame.height - 4
           )
       }
    
    // MARK: - Initializers
    
    init(with type: PlayType) {
        playType = type
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        playType = .view
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Methods
    
    private func commonInit() {
        setupBackgroundColor(.systemBackground)
        setupNavigationBar()
        setupSubview()
        setupConstraint()
        setupViewTypeLabelText(with: playType)
        setupPlayButtonAndTypeLabel(with: playType)
        setupPlayButton()
    }
    
    private func setupBackgroundColor(_ color: UIColor?) {
        view.backgroundColor = color
    }
    
    private func setupNavigationBar() {
        setupNavigationBarTitle()
        setupNavigationBackButton()
    }
    
    private func setupNavigationBarTitle() {
        navigationItem.title = "다시보기"
        let attribute = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attribute
    }
    
    private func setupNavigationBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupPlayButton() {
        playButton.addTarget(
            self,
            action: #selector(playButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupSubview() {
        [dateLabel, viewTypeLabel, gridView, graphView, playButton, playTimeLabel]
            .forEach { view.addSubview($0) }
    }
    
    private func setupConstraint() {
        setupDateLabelConstraint()
        setupViewTypeLabelConstraint()
        setupGraphViewConstraint()
        setupPlayButtonConstraint()
        setupPlayTimeLabelConstraint()
    }
    
    private func setupDateLabelConstraint() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            dateLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 28
            )
        ])
    }
    
    private func setupViewTypeLabelConstraint() {
        NSLayoutConstraint.activate([
            viewTypeLabel.topAnchor.constraint(
                equalTo: dateLabel.bottomAnchor,
                constant: 8
            ),
            viewTypeLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 28
            )
        ])
    }
    
    private func setupGraphViewConstraint() {
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(
                equalTo: viewTypeLabel.bottomAnchor,
                constant: 32
            ),
            gridView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            gridView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            ),
            gridView.heightAnchor.constraint(
                equalTo: gridView.widthAnchor
            )
        ])
    }
    
    private func setupPlayButtonConstraint() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            playButton.topAnchor.constraint(
                equalTo: gridView.bottomAnchor,
                constant: 40
            ),
            playButton.widthAnchor.constraint(
                equalTo: gridView.widthAnchor,
                multiplier: 1/4
            ),
            playButton.heightAnchor.constraint(
                equalTo: playButton.widthAnchor
            )
        ])
    }
    
    private func setupPlayTimeLabelConstraint() {
        NSLayoutConstraint.activate([
            playTimeLabel.centerYAnchor.constraint(
                equalTo: playButton.centerYAnchor
            ),
            playTimeLabel.trailingAnchor.constraint(
                equalTo: gridView.trailingAnchor
            )
        ])
    }
    
    private func setupViewTypeLabelText(with type: PlayType) {
        switch type {
        case .view:
            viewTypeLabel.text = "View"
        case .play:
            viewTypeLabel.text = "Play"
        }
    }
    
    private func setupPlayButtonAndTypeLabel(with type: PlayType) {
        switch type {
        case .view:
            playButton.isHidden = true
            playTimeLabel.isHidden = true
        case .play:
            playButton.isHidden = false
            playTimeLabel.isHidden = false
        }
    }
    
    @objc private func playButtonTapped() {
        graphView.startAnimation()
        var timeCount: Double = 0.0
                
        if playButton.image(for: .normal) == UIImage(systemName: "play.fill") {
            playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                self.playTimeLabel.text = String(format: "%.2f", timeCount)
                timeCount += 0.1
            }
        } else if playButton.image(for: .normal) == UIImage(systemName: "stop.fill") {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer?.invalidate()
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        print("saved")
    }
}
