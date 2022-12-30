//
//  MotionPlayViewControllers.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/29.
//

import UIKit

final class MotionPlayViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    private let viewModel: MotionPlayViewModel
    private var drawingIndex = 0

    
    init(viewModel: MotionPlayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.viewType == .view {
            if let datas = viewModel.motions.value {
                graphView.drawGraph(datas: datas)
            }
        }
    }
    
    private func bind() {
        dateLabel.text = viewModel.date.formatted(for: .display)
        titleLabel.text = viewModel.viewType.toTitle()
        
        if viewModel.viewType == .play {
            playingTimeLabel.isHidden = false
            self.viewModel.playStatus.observe(on: self) { [weak self] playStatus in
                switch playStatus {
                case .play:
                    self?.graphView.clean()
                    self?.playButton.isHidden = true
                    self?.pauseButton.isHidden = false
                    self?.drawingIndex = 0
                case .stop:
                    self?.playButton.isHidden = false
                    self?.pauseButton.isHidden = true
                }
            }
            self.viewModel.playingTime.observe(on: self) { [weak self] playingTime in
                self?.playingTimeLabel.text = String(format: "%03.1f", playingTime)
            }
            self.viewModel.playMotion.observe(on: self) { [weak self] motionValue in
                self?.graphView.drawGraph(data: motionValue)
            }
        }
    }
    
    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1, scale: .large)
        let image = UIImage(systemName: "play.fill")?.withConfiguration(config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(startDraw(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1, scale: .large)
        let image = UIImage(systemName: "pause.fill")?.withConfiguration(config)
        button.isHidden = true
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pauseDraw(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: 8)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(dateLabel, titleLabel)
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2022/09/08 14:50:43"
        label.font = .preferredFont(for: .footnote, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "View"
        label.font = .preferredFont(for: .title1, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var playingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00.0"
        label.font = .preferredFont(for: .title1, weight: .semibold)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    @objc func startDraw(_ sender: UIButton) {
        viewModel.playStart()
    }
    
    @objc func pauseDraw(_ sender: UIButton) {
        viewModel.playStop()
    }
}

private extension MotionPlayViewController {
    
    enum ConstantLayout {
        static let offset: CGFloat = 30
        static let buttonSize: CGFloat = 100
    }
    
    func setUp() {
        setUpView()
        setUpNavigationBar()
    }
    
    func setUpView() {
        view.addSubviews(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelStackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: ConstantLayout.offset
            )
        ])
        
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: ConstantLayout.offset
            ),
            graphView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -ConstantLayout.offset
            ),
            graphView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 20),
            graphView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        view.addSubviews(playingTimeLabel)
        NSLayoutConstraint.activate([
            playingTimeLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: ConstantLayout.offset),
            playingTimeLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor)
        ])
        
        view.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: ConstantLayout.offset),
            playButton.heightAnchor.constraint(equalToConstant: ConstantLayout.buttonSize),
            playButton.widthAnchor.constraint(equalToConstant: ConstantLayout.buttonSize)
        ])
        
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: ConstantLayout.offset),
            pauseButton.heightAnchor.constraint(equalToConstant: ConstantLayout.buttonSize),
            pauseButton.widthAnchor.constraint(equalToConstant: ConstantLayout.buttonSize)
        ])
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "다시보기"
    }
    
}
