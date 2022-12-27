//
//  MotionRecordingViewController.swift
//  GyroData
//
//  Created by YunYoungseo on 2022/12/27.
//

import UIKit

final class MotionRecordingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "측정하기"
        view.backgroundColor = .systemBackground

        let recordingView = MotionRecordingView()
        recordingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordingView)
        NSLayoutConstraint.activate([
            recordingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recordingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recordingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
