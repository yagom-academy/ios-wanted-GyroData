//
//  MotionGraphViewController.swift
//  GyroData
//
//  Created by Ayaan, Wonbi on 2023/01/31.
//

import UIKit

final class MotionGraphViewController: UIViewController {
    enum Constant {
        static let title = "다시보기"
        static let margin = CGFloat(16.0)
        static let spacing = CGFloat(8.0)
    }
    enum Style {
        case play, view
        
        var title: String {
            switch self {
            case .play:
                return "Play"
            case .view:
                return "View"
            }
        }
    }
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    private let graphView = UIView()
    private let playButton = PlayButton()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .right
        return label
    }()
    private let spaceView = UIView()
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.spacing
        return stackView
    }()
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let style: Style
    private let viewModel: MotionGraphViewModel
    
    init(style: Style, viewModel: MotionGraphViewModel) {
        self.style = style
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
        viewModel.configureDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action(.viewWillAppear)
    }
}

private extension MotionGraphViewController {
    func setupUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.backgroundColor = .systemBackground
        title = Constant.title
        [spaceView, playButton, timeLabel].forEach(bottomStackView.addArrangedSubview(_:))
        [dateLabel, titleLabel, graphView, bottomStackView].forEach(contentsStackView.addArrangedSubview(_:))
        view.addSubview(contentsStackView)
        
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                   constant: Constant.margin),
            contentsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                       constant: Constant.margin),
            contentsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                        constant: -Constant.margin),
            contentsStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor,
                                                      constant: -Constant.margin),
            graphView.widthAnchor.constraint(equalTo: contentsStackView.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: graphView.heightAnchor),
            playButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.06),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            spaceView.widthAnchor.constraint(equalTo: timeLabel.widthAnchor)
        ])
        
        bottomStackView.isHidden = style == .view
    }
    
    func setupButton() {
        playButton.setActiveHandler {
            //write active action
        }
        playButton.setInactiveHandler {
            //write active inaction
        }
    }
}

extension MotionGraphViewController: MotionGraphViewModelDelegate {
    func motionGraphViewModel(willDisplayDate date: String, type: String, data: Motion.MeasurementData) {
        dateLabel.text = date
        titleLabel.text = "\(type) \(style.title)"
    }
}
