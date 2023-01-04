//
//  MeasureView.swift
//  GyroData
//
//  Created by 이원빈 on 2022/12/29.
//

import UIKit

final class MeasureView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
        return stack
    }()
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Acc", "Gyro"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let graphContainerView: GraphContainerView = {
        let view = GraphContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("측정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정지", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubviews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMode(with viewModel: MeasureViewModel) {
        graphContainerView.graphView.receive(
            x: viewModel.myX.axisDecimal(),
            y: viewModel.myY.axisDecimal(),
            z: viewModel.myZ.axisDecimal()
        )
    }
    
}

private extension MeasureView {
    func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(segmentControl)
        stackView.addArrangedSubview(graphContainerView)
        stackView.addArrangedSubview(startButton)
        stackView.addArrangedSubview(stopButton)
    }
    
    func setLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            graphContainerView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}

