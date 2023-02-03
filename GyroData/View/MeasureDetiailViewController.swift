//
//  MeasureDetailViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import UIKit

class MeasureDetailViewController: UIViewController {
    let viewModel: MeasureDetailViewModel
    
    var graphView: GraphView = {
        let view = GraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        button.setImage(UIImage(systemName: "stop.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(viewModel: MeasureDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureLayout()
        configureAction()
        configureBind()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loading = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureGraphView()
    }
    
    func configureLayout() {
        view.addSubview(dateLabel)
        view.addSubview(pageLabel)
        view.addSubview(graphView)
        view.addSubview(buttonStackView)
        view.addSubview(timeLabel)
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(stopButton)
        view.addSubview(indicatorView)
        
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            pageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            pageLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            graphView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 20),
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            buttonStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            buttonStackView.heightAnchor.constraint(equalToConstant: 80),
            
            timeLabel.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: buttonStackView.trailingAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: graphView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: graphView.centerYAnchor)
        ])
    }
    
    func configureNavigationBar() {
        navigationItem.title = "다시보기"
    }
    
    func configureBind() {
        viewModel.bindStartLoading {
            self.indicatorView.startAnimating()
        }
        
        viewModel.bindStopLoading {
            self.indicatorView.stopAnimating()
        }
        
        viewModel.bindDrawGraphView { coordinate in
            self.graphView.drawLine(x: coordinate.x, y: coordinate.y, z: coordinate.z)
        }
        
        viewModel.bindSecond {
            self.timeLabel.text = $0?.description
        }
        
        viewModel.bindPlayButton {
            self.playButton.isHidden = $0
        }
        
        viewModel.bindStopButton {
            self.stopButton.isHidden = $0
        }
        
    }
    
    func configureAction() {
        playButton.addTarget(self, action: #selector(playDrawGraph), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopDrawGraph), for: .touchUpInside)
    }
    
    func configureGraphView() {
        graphView.configureData()
        viewModel.graphViewLoad()
    }
    
    func configureData() {
        viewModel.fetchData()
        viewModel.load()
        pageLabel.text = viewModel.pageType.rawValue
        dateLabel.text = viewModel.motionData.date?.formatted("yyyy/MM/dd HH:mm:ss")
    }
    
    @objc func playDrawGraph() {
        graphView.configureData()
        viewModel.start()
    }
    
    @objc func stopDrawGraph() {
        viewModel.stop()
    }
    
}
