//
//  DetailViewController.swift
//  GyroData
//
//  Created by 리지 on 2023/06/14.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    
    private var pageType: PageType
    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var isPlaying: Bool = false
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    private lazy var pageTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = pageType.description
        return label
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let lineWidth: CGFloat = 3
        view.layer.borderWidth = lineWidth
        
        return view
    }()
    
    private lazy var graphView: GraphView = {
        let view = GraphView(frame: .zero, viewModel: viewModel.timerViewModel)
        
        return view
    }()
    
    private let playStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 100
        
        return stackView
    }()
    
    private lazy var playButton: PlayButton = {
        let button = PlayButton()
        
        switch pageType {
        case .view:
            button.isHidden = true
        case .play:
            button.isHidden = false
        }
        
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00.0"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .black
        
        return label
    }()
    
    init(pageType: PageType, viewModel: DetailViewModel) {
        self.pageType = pageType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.timerViewModel.restartTimer()
    }
    
    private func bind() {
        viewModel.$currentData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.dateLabel.text = self?.viewModel.date
                
                guard let id = data?.id,
                      let data = self?.viewModel.fetchData(by: id),
                      let threeAxisValue = data.threeAxisValue else { return }
                
                switch self?.pageType {
                case .view:
                    self?.graphView.drawGraph(with: threeAxisValue)
                default:
                    return
                }
            }
            .store(in: &cancellables)
        viewModel.$timerLabel
            .sink { [weak self] label in
                self?.timerLabel.text = label
            }
            .store(in: &cancellables)
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpUI()
        configurePlayButton()
    }
    
    private func setUpNavigationBar() {
        let title = "다시보기"
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setUpUI() {
        view.addSubview(labelStackView)
        view.addSubview(borderView)
        view.addSubview(playStackView)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(pageTypeLabel)
        borderView.addSubview(graphView)
        playStackView.addArrangedSubview(playButton)
        playStackView.addArrangedSubview(timerLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        let labelStackViewHorizontal: CGFloat = 30
        let bottom: CGFloat = -280
        let top: CGFloat = 10
        let playStackViewTop: CGFloat = 20
        let playStackViewLeading: CGFloat = 150
        let graphViewAllConstant: CGFloat = 5
    
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        borderView.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        playStackView.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: labelStackViewHorizontal),
            labelStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: labelStackViewHorizontal * -1),
            
            borderView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: top),
            borderView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            borderView.widthAnchor.constraint(equalTo: borderView.heightAnchor),
            
            graphView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: graphViewAllConstant),
            graphView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: graphViewAllConstant),
            graphView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: graphViewAllConstant * -1),
            graphView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: graphViewAllConstant * -1),
            
            playStackView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: playStackViewTop),
            playStackView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: playStackViewLeading),
            playStackView.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            playStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: bottom),
        ])
    }
    
    private func configurePlayButton() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc private func playButtonTapped() {
        if isPlaying == false {
            viewModel.timerViewModel.restartTimer()
            playButton.setUpStopMode()
            guard let data = viewModel.currentData else { return }
            playGraph(data)
            isPlaying = true
        } else {
            viewModel.timerViewModel.stopTimer(true)
            playButton.setUpPlayMode()
            isPlaying = false
        }
    }
    
    private func playGraph(_ data: GyroEntity) {
        guard let id = data.id,
              let data = viewModel.fetchData(by: id),
              let threeAxisValue = data.threeAxisValue else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.graphView.drawGraphByTenthOfASecond(with: threeAxisValue)
        }
    }
}
