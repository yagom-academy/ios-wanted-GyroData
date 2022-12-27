//
//  MeasurementReplayViewController.swift
//  GyroData
//
//  Created by bard on 2022/12/26.
//

import UIKit

final class MeasurementReplayViewController: UIViewController {
    
    // MARK: Properties
    
    private let playType: PlayType
    
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
    
    private let graphView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        return view
    }()
    
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
    
    private func setupSubview() {
        [dateLabel, viewTypeLabel, graphView, playButton, playTimeLabel]
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
            graphView.topAnchor.constraint(
                equalTo: viewTypeLabel.bottomAnchor,
                constant: 32
            ),
            graphView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            graphView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -40
            ),
            graphView.heightAnchor.constraint(
                equalTo: graphView.widthAnchor
            )
        ])
    }
    
    private func setupPlayButtonConstraint() {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            playButton.topAnchor.constraint(
                equalTo: graphView.bottomAnchor,
                constant: 40
            ),
            playButton.widthAnchor.constraint(
                equalTo: graphView.widthAnchor,
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
                equalTo: graphView.trailingAnchor
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
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        print("saved")
    }
}
