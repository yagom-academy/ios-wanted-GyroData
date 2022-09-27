//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 박호현 on 2022/09/24.
//

import UIKit

class ReplayViewController: UIViewController {
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.text = "2022/09/07 15:10:11"
        return label
    }()
    
    var typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.text = "View"
        return label
    }()
    
    var playTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30)
        label.text = "30.1"
        return label
    }()
    
    var graphView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    lazy var playButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        button.setImage(UIImage.init(named: "play.fill"), for: .normal)
        button.backgroundColor = .systemBackground
        return button
    }()
    
    lazy var stopButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
        button.setImage(UIImage.init(named: "stop.fill"), for: .normal)
        button.backgroundColor = .systemBackground
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureViews()
        configureLayout()
    }
    
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(dateLabel)
        view.addSubview(typeLabel)
        view.addSubview(playTimeLabel)
        view.addSubview(graphView)
        view.addSubview(playButton)
        view.addSubview(stopButton)
    }
    
    private func configureNavigation() {
        navigationItem.title = "다시보기"
    }
    
    private func configureLayout() {
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            typeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            graphView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 20),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            
            playButton.widthAnchor.constraint(equalToConstant: 44),
            playButton.heightAnchor.constraint(equalToConstant: 44),
            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stopButton.widthAnchor.constraint(equalToConstant: 44),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            stopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playTimeLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 50),
            playTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    @objc func didTapPlayButton() {
        playButton.isHidden = true
        stopButton.isHidden = false
    }
    
    @objc func didTapStopButton() {
        stopButton.isHidden = true
        playButton.isHidden = false
    }
    
}
