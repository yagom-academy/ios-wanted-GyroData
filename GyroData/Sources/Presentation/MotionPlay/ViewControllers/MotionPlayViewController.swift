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
    private var timer = Timer()
    
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
        dateLabel.text = viewModel.date.formatted()
        titleLabel.text = viewModel.viewType.toTitle()
        
        if viewModel.viewType == .play {
            self.viewModel.playStatus.observe(on: self) { [weak self] playStatus in
                switch playStatus {
                case .play:
                    self?.graphView.clean()
                    self?.playButton.isHidden = true
                    self?.pauseButton.isHidden = false
                    self?.drawingIndex = 0
                    self?.startTimer()
                case .stop:
                    self?.playButton.isHidden = false
                    self?.pauseButton.isHidden = true
                    self?.timer.invalidate()
                }
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
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(drawGraph),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func startDraw(_ sender: UIButton) {
        viewModel.playStart()
    }
    
    @objc func pauseDraw(_ sender: UIButton) {
        viewModel.playStop()
    }
    
    @objc func drawGraph() {
        if drawingIndex == viewModel.motions.value?.count {
            viewModel.playStop()
        } else {
            let motion = viewModel.motions.value?[drawingIndex]
            graphView.drawGraph(data: motion)
            drawingIndex += 1
        }
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
