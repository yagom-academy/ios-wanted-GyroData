//
//  MotionPlayViewControllers.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/29.
//

import UIKit

final class MotionPlayViewControllers: UIViewController {
    
    weak var coordinator: Coordinator?
    private let viewModel: MotionPlayViewModel
    
    init(viewModel: MotionPlayViewModel,
         coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bind()
    }
    
    private func bind() {
        switch viewModel.viewType {
        case .play:
            self.viewModel.currentMotion.observe(on: self) { [weak self] motionValue in
                self?.graphView.drawGraph(data: motionValue)
            }
            self.viewModel.playStatus.observe(on: self) { [weak self] playStatus in
                switch playStatus {
                case .play:
                    self?.playButton.isHidden = false
                    self?.pauseButton.isHidden = true
                case .stop:
                    self?.playButton.isHidden = false
                    self?.pauseButton.isHidden = true
                }
            }
        case .view:
            self.viewModel.motions.observe(on: self) { [weak self] motionValues in
                guard let motionValues = motionValues else {
                    return
                }
                self?.graphView.drawGraph(data: motionValues)
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
        let image = UIImage(systemName: "Play")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(startDraw(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "Pause")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pauseDraw(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func startDraw(_ sender: UIButton) {
        viewModel.playStop()
    }
    
    @objc func pauseDraw(_ sender: UIButton) {
        viewModel.playStop()
    }
}

extension MotionPlayViewControllers {
    
    private enum ConstantLayout {
        static let offset: CGFloat = 30
        static let buttonSize: CGFloat = 50
    }
    
    private func setUpView() {
        
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantLayout.offset),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstantLayout.offset),
            graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: ConstantLayout.offset),
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
}
