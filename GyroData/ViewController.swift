//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class ViewController: UIViewController {

    private let graphView = GraphView()

    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)

        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

