//
//  GraphContainerView.swift
//  GyroData
//
//  Created by minsson on 2022/12/29.
//

import UIKit

final class GraphContainerView: UIView {
    private enum Configuration {
        static let borderWidth: CGFloat = 4
        static let edgeDistance: CGFloat = 10
    }
    
    private let graphBackgroundView: GraphBackgroundView = {
        let graphBackgroundView = GraphBackgroundView()
        graphBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        return graphBackgroundView
    }()
    
    let graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        return graphView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupRootView()
        
        addViews()
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GraphContainerView {
    func setupRootView() {
        self.backgroundColor = .clear
        self.layer.borderWidth = Configuration.borderWidth
    }
    
    func addViews() {
        addSubview(graphView)
        addSubview(graphBackgroundView)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            graphBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: Configuration.edgeDistance),
            graphBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Configuration.edgeDistance),
            graphBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Configuration.edgeDistance),
            graphBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Configuration.edgeDistance),
            
            graphView.topAnchor.constraint(equalTo: graphBackgroundView.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: graphBackgroundView.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: graphBackgroundView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: graphBackgroundView.trailingAnchor)
        ])
    }
}
