//
//  ReviewPageView.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/01.
//

import UIKit

final class ReviewView: UIView {

    enum PageState {

        case resultView
        case resultPlay

        var pageName: String {
            switch self {
            case .resultView:
                return "View"
            case .resultPlay:
                return "Play"
            }
        }
    }
    
    private let pageState: PageState
    private let dateLabel = UILabel(font: .body)
    private let pageStateLabel = UILabel(font: .title1)
    private let timeLabel = UILabel(text: "0.0", font: .title1, textAlignment: .right)
    private let graphStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 30)
    private let playStackView = UIStackView(distribution: .fill, alignment: .center)
    private let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        let playImage = UIImage(systemName: "play.fill")
        button.setBackgroundImage(playImage, for: .normal)
        button.tintColor = .label
        button.isSelected = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private lazy var graphView = GraphView()

    var state: PageState {
        return pageState
    }
    
    var isPlayButton: Bool {
        return playButton.isSelected
    }
    
    init(pageState: PageState) {
        self.pageState = pageState
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout(pageState: pageState)
        setupPageStateLabelText(pageState: pageState)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDateLabelText(_ text: String) {
        dateLabel.text = text
    }

    func setupButtonAction(action: UIAction) {
        playButton.addAction(action, for: .touchUpInside)
    }

    func setupTimeLabel(string: String) {
        timeLabel.text = string
    }
    
    func showGraph(with data: [AxisValue]) {
        graphView.viewModel.setAxisValues(data)
    }
    
    func clearGraph() {
        graphView.viewModel.setAxisValues([])
    }
    
    func drawGraph(with data: AxisValue) {
        graphView.viewModel.addAxisValue(data)
    }
    
    func togglePlayButton() {
        if playButton.isSelected {
            playButton.isSelected = false
            playButton.setBackgroundImage(UIImage(systemName: "stop.fill"), for: .normal)
            clearGraph()
        } else {
            playButton.isSelected = true
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    private func setupPageStateLabelText(pageState: PageState) {
        pageStateLabel.text = pageState.pageName
    }
}

// MARK: Layout
extension ReviewView {
    
    private func configureHierarchy() {
        [dateLabel, pageStateLabel, graphView].forEach { view in
            graphStackView.addArrangedSubview(view)
        }
        
        self.addSubview(graphStackView)
        
        if pageState == .resultPlay {
            [playButton, timeLabel].forEach { view in
                playStackView.addArrangedSubview(view)
            }
            
            self.addSubview(playStackView)
        }
    }
    
    private func configureLayout(pageState: PageState) {
        switch pageState {
        case .resultView:
            configureGraphStackViewLayout()
        case .resultPlay:
            configureGraphStackViewLayout()
            configurePlayStackViewLayout()
        }
    }
    
    private func configureGraphStackViewLayout() {
        graphStackView.setCustomSpacing(5, after: dateLabel)
        pageStateLabel.setContentHuggingPriority(.init(1), for: .vertical)

        NSLayoutConstraint.activate([
            graphStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            graphStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            graphStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            graphStackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor,  multiplier: 0.6),
            
            graphView.widthAnchor.constraint(equalTo: graphStackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor)
        ])
    }
    
    private func configurePlayStackViewLayout() {
        NSLayoutConstraint.activate([
            playStackView.topAnchor.constraint(equalTo: graphStackView.bottomAnchor, constant: 30),
            playStackView.trailingAnchor.constraint(equalTo: graphStackView.trailingAnchor),
            playStackView.widthAnchor.constraint(equalTo: graphStackView.widthAnchor, multiplier: 0.6),
            
            playButton.widthAnchor.constraint(equalTo: graphStackView.widthAnchor, multiplier: 0.2),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
        ])
    }
}
