//
//  PlayGyroViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

import UIKit

class PlayGyroViewController: UIViewController {
    enum Mode {
        case play
        case view
        
        var description: String {
            switch self {
            case .play:
                return "Play"
            case .view:
                return "View"
            }
        }
    }

    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, graphView])

        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        return stackView
    }()
    private lazy var labelStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, titleLabel])

        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let dateLabel = UILabel()
    private let titleLabel = UILabel()
    private let graphView: GraphView
    private let gyroData: GyroData
    private let mode: Mode
    
    init(viewMode: PlayGyroViewController.Mode, gyroData: GyroData) {
        mode = viewMode
        graphView = GraphView(gyroData: gyroData)
        self.gyroData = gyroData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDateLabel()
        setupTitleLabel()
        layout()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupDateLabel() {
        guard let date = gyroData.date else { return }
        
        let formattedDate = DateFormatter.dateToText(date)
        
        dateLabel.text = formattedDate
        dateLabel.textAlignment = .left
        dateLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = mode.description
        titleLabel.textAlignment = .left
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
    }

    private func layout() {
        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -32),

            graphView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}
