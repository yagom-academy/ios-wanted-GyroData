//
//  ReplayMotionViewController.swift
//  GyroData
//
//  Created by Aaron, Gundy on 2023/01/31.
//

import UIKit

class ReplayMotionViewController: UIViewController {

    private var replayMotionViewModel: ReplayMotionViewModel?

    init(replayMotionViewModel: ReplayMotionViewModel? = ReplayMotionViewModel()) {
        self.replayMotionViewModel = replayMotionViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    let typeLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    let graphView: UIView = {
        let view = UIView()

        return view
    }()

    let playButton: UIButton = {
        let btn = UIButton()

        return btn
    }()

    let stopButton: UIButton = {
        let btn = UIButton()

        return btn
    }()

    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [playButton, stopButton])
        stackView.axis = .horizontal

        return stackView
    }()

    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, typeLabel, graphView, buttonStackView])
        stackView.spacing = 8
        return stackView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
    }

    // MARK: - setUp UI
    func configureUI() {
        configureHierarchy()
        configureLayout()
        configureNavigation()
    }

    func configureHierarchy() {
        view.addSubview(containerStackView)
    }

    func configureLayout() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.heightAnchor.constraint(equalToConstant: 16),

            typeLabel.heightAnchor.constraint(equalToConstant: 36),

            graphView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),

            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureNavigation() {
        self.navigationController?.title = "다시 보기"
    }

    // MARK: - binding Data



}
