//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import UIKit
import SnapKit

class ReplayViewController: UIViewController {
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "다시보기"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let measureDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2020/09/07 HH:MM:nn"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "View"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "11:00"
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.setupLayouts()
        self.btnAddTarget()
    }

    // MARK: - configure
    private func setupLayouts() {
        self.view.addSubViews(
            self.navigationTitle,
            self.navigationBackButton,
            self.measureDateLabel,
            self.stateLabel,
            self.graphView,
            self.playButton,
            self.timerLabel
        )
        
        self.navigationBackButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.size.equalTo(30)
            $0.leading.equalToSuperview().offset(23)
        }
        
        self.navigationTitle.snp.makeConstraints {
            $0.top.equalTo(self.navigationBackButton.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        
        self.measureDateLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationTitle.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.stateLabel.snp.makeConstraints {
            $0.top.equalTo(self.measureDateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        self.graphView.snp.makeConstraints {
            $0.top.equalTo(self.stateLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(200)
        }
        
        self.playButton.snp.makeConstraints {
            $0.top.equalTo(self.graphView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        self.timerLabel.snp.makeConstraints {
            $0.top.equalTo(self.graphView.snp.bottom).offset(40)
            $0.leading.equalTo(self.playButton.snp.trailing).offset(50)
        }
    }
    
    private func btnAddTarget() {
        navigationBackButton.addTarget(self, action: #selector(tapBackBtn(_:)), for: .touchUpInside)
    }
    
    // MARK: - private func
    @objc func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
