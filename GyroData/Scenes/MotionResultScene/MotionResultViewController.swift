//
//  MotionResultViewController.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/28.
//

import UIKit

class MotionResultViewController: UIViewController {

    let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let graphView: GraphView = {
        let graph = GraphView()
        graph.translatesAutoresizingMaskIntoConstraints = false
        return graph
    }()

    let viewModel: MotionResultViewModel
    
    init(viewModel: MotionResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureNavigationBar()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.load()
        // startIndicator
    }
    
    func bind(to viewModel: MotionResultViewModel) {
        viewModel.motionInformation.subscribe { [weak self] motionInformation in
            guard let motionInformation = motionInformation else { return }
            self?.configureUI(motionInformation: motionInformation)
            self?.drawGraph(motion: motionInformation)
        }
    }
    
    private func setupView() {
        addSubViews()
        setupConstraints()
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        entireStackView.addArrangedSubview(informationStackView)
        entireStackView.addArrangedSubview(graphView)
        
        informationStackView.addArrangedSubview(dateLabel)
        informationStackView.addArrangedSubview(titleLabel)
        
        view.addSubview(entireStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 16),
            entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                 constant: 30),
            entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: -30),
            
            graphView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "다시보기"
    }
    
    private func configureUI(motionInformation: MotionInformation) {
        dateLabel.text = "\(motionInformation.motion.date)"
        titleLabel.text = motionInformation.motion.motionType.rawValue
    }

    func drawGraph(motion: MotionInformation) {
        let motionDatas = zip(motion.xData, zip(motion.yData, motion.zData))
        let minCount = min(motion.xData.count, motion.yData.count, motion.zData.count)
        let width = CGFloat((view.bounds.width - 60.0) / Double(minCount))
       
        graphView.clearSegmanet()
        
        if width < GraphNumber.segmentWidth {
            graphView.setupSegmentSize(width: width, height: view.bounds.width)
        } else {
            graphView.setupSegmentSize(height: view.bounds.width)
        }
        
        for (x, (y, z)) in motionDatas {
            graphView.add([x, y, z])
        }
    }
}
