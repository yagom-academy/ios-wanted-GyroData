//
//  ReviewPageViewController.swift
//  GyroData
//
//  Created by 써니쿠키 on 2023/02/02.
//

import UIKit

final class ReviewPageViewController: UIViewController {
    private let reviewPageView: ReviewPageView
    private let measurement: Measurement
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = reviewPageView

        configureView()
    }
    
    init(reviewPageView: ReviewPageView, measurement: Measurement) {
        self.reviewPageView = reviewPageView
        self.measurement = measurement
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        switch reviewPageView.state {
        case .resultView:
            reviewPageView.showGraph(with: measurement.axisValues)
        case .resultPlay:
            let action = UIAction { [weak self] _ in
                self?.replayGraph()
            }
            reviewPageView.configureButtonAction(action: action)
        }
        
        reviewPageView.setupDateLabelText(measurement.date.makeSlashFormat())
    }

    private func resetTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    private func replayGraph() {
        var axisValues = measurement.axisValues
        var time = 0.0

        if reviewPageView.isPlayButton {
            reviewPageView.togglePlayButton()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard axisValues.first != nil else {
                    self?.resetTimer()
                    return
                }

                time += 0.1
                self?.reviewPageView.drawGraph(with: axisValues.removeFirst())
                self?.reviewPageView.configureTimeLabel(string: String(format: "%.1f", time))
            }
        } else {
            reviewPageView.togglePlayButton()
            resetTimer()
        }
    }
}
