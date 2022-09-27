//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 김지인 on 2022/09/21.
//

import UIKit
import SnapKit

enum PageType: String {
    case view = "View"
    case play = "Play"
}

class ReplayViewController: UIViewController {
    
    private var timer: Timer?
    //첫번째화면에서 받아올 데이터
    var measureData: Measure = Measure(title: "안들어있음", second: 0.0, pageType: .view) {
        didSet {
            self.measureDateLabel.text = String(measureData.measureDate)
            self.stateLabel.text = measureData.pageType?.rawValue
        }
    }
    let stepDuration = 0.1
    var aData: CGFloat = 0.0
    var bData: CGFloat = 0.0
    var cData: CGFloat = 0.0
    var pageTypeName: PageType = .play {
        didSet {
            self.graphView.viewTypeIsPlay = pageTypeName
        }
    }
    var aBuffer = GraphBuffer(count: 100)
    var bBuffer = GraphBuffer(count: 100)
    var cBuffer = GraphBuffer(count: 100)
    private var timerValid: Bool = false
    private var startTime: Double = 00.0{
        didSet {
            timerLabel.text = String(format: "%.1f", startTime)
        }
    }
    
    var sensorData: CGFloat = 0.0
    var buffer = GraphBuffer(count: 100)
    var countDown: Double = 0.0
    
    // MARK: - Component
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
    
    private let graphView: GraphView = {
        let view = GraphView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        return label
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.setupLayouts()
        self.btnAddTarget()
        self.setupGraphView()
        if pageTypeName == .view {
            dummyTestViewShow()
        }
    }
    
    // MARK: - private func
    private func setupLayouts() {
        
        self.view.addSubViews(
            self.navigationTitle,
            self.navigationBackButton,
            self.measureDateLabel,
            self.stateLabel,
            self.graphView
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
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        if pageTypeName == .play {
            self.view.addSubViews(
                self.playButton,
                self.timerLabel
            )
            self.playButton.snp.makeConstraints {
                $0.top.equalTo(self.graphView.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(80)
            }
            self.timerLabel.snp.makeConstraints {
                $0.top.equalTo(self.playButton.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
            }
        }
        
    }
    
    private func setupGraphView() {
        graphView.aPoint = aBuffer
        graphView.bPoint = bBuffer
        graphView.cPoint = cBuffer
    }
    
    private func btnAddTarget() {
        navigationBackButton.addTarget(self, action: #selector(backButtonTap(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTap(_:)), for: .touchUpInside)
    }
    
    private func dummyTestViewShow() {
        let result = JsonFetchManager.shared.request(id: "D1CE2BE2-1BD2-40AD-9A4A-BEA7C89E5AB2")
        switch result {
        case .success(let data):
            self.graphView.graphData = data
            self.graphView.gyroListGraphShow()
        case .failure(let error):
            debugPrint(error)
        }
    }
    
    // MARK: - #selector
    @objc func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func playButtonTap(_ sender: UIButton) {
        print("측정")
        timerValid.toggle()
        if timerValid {
            countDown = 600
            timer = Timer.scheduledTimer(withTimeInterval: 0.1
                                         , repeats: true) { [weak self] (timer) in
                guard let self = self else { return }
                //랜덤값이 아닌 파일매니저의 값을 받아와서 써야함
                let result = MeasureFileManager.shared.loadFile(self.measureData)
                switch result {
                case .success(let data):
                    self.graphView.graphData = data
                    self.graphView.gyroListGraphShow()
                    self.countDown -= 0.1
                    self.startTime += 0.1
                    if self.countDown <= 0 {
                        timer.invalidate()
                    }
                case .failure(let error):
                    debugPrint("FileManager fetch fail", error)
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
            self.graphView.reset()
            self.startTime = 0
        }
        let image = timerValid ? UIImage(systemName: "stop.fill") : UIImage(systemName: "play.fill")
        playButton.setImage(image, for: .normal)
    }
}



