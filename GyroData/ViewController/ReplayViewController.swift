//
//  ReplayViewController.swift
//  GyroData
//
//  Created by 유영훈 on 2022/09/20.
//

import UIKit
import CoreData

class ReplayViewController: UIViewController {

    let graphViewMaker = GraphViewMaker.shared
    
    // TEST
    var xValue: Float = 0.0
    var yValue: Float = 0.0
    var ySubValue: Float = 0.0
    var zValue: Float = 0.0
    
    /// 그래프 뷰의 Height
    let graphViewHeight: CGFloat = 280.0
    
    /// 그래프 뷰의 Width
    let graphViewWidth: CGFloat = 280.0
    
    /// 1개의 데이터가 차지할 width
    var blockWidth: CGFloat = 0.0

    /// 그래프 기준점
    var graphBaseHeight: CGFloat = 0.0
    
    /// 그래프 뷰
    lazy var graphView = graphViewMaker.graphView
    
    /**
        세번째 페이지의 타입을 정하는 변수
     
        - "View" 타입은 모든데이터를 한번에 보여주는 뷰
        - "Play" 타입은 타이머를 통해 애니메이션으로 보여주는 뷰
        - 기본값 "Play"
     */
    var pageType: String = "View"
    
    var timestamp: String = "ex)2022/09/12 12:33:02"
    
    /// 센서 측정 시작 버튼
    lazy var playButton: UIButton = {
        let symbolSize = UIImage.SymbolConfiguration(pointSize: 45)
        let button = UIButton(type: .system)
            button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return button
    }()
    
    /// 센서 측정 중지 버튼
    lazy var stopButton: UIButton = {
        let symbolSize = UIImage.SymbolConfiguration(pointSize: 45)
        let button = UIButton(type: .system)
            button.setPreferredSymbolConfiguration(symbolSize, forImageIn: .normal)
            button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
        return button
    }()
    
    /// 빈 블럭
    lazy var invisibleBlock: UILabel = {
        let label = UILabel()
            label.text = " "
        return label
    }()
    
    /// 타이머 시간을 표시할 라벨
    lazy var timeLabel: UILabel = {
        let label = CommonUIModule().creatLabel(text: "0.0", color: .black, alignment: .right, fontSize: 20, fontWeight: .regular)
        return label
    }()
    
    /// 뷰 타입에 따른 타이틀 "Play" or "View"
    lazy var titleLabel: UILabel = {
        let label = CommonUIModule().creatLabel(text: "Play", color: .black, alignment: .left, fontSize: 30, fontWeight: .semibold)
        return label
    }()
    
    /// 센서 기록을 측정한 시간
    lazy var timestampLabel: UILabel = {
        let label = CommonUIModule().creatLabel(text: "", color: .black, alignment: .left, fontSize: 15, fontWeight: .regular)
        return label
    }()
    
    /// 재생, 정지, 타이머라벨을 표시 뷰
    lazy var playPannelStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    /// 타이틀, 측정시간 표시  뷰
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.axis = .vertical
        return stackView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        graphViewMaker.stop()
        graphViewMaker.resetGraph()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphViewMaker.delegate = self
        
        // MARK: UI Set
        self.view.backgroundColor = .white
        self.navigationItem.title = "다시보기"
        self.navigationController?.navigationBar.tintColor = .black
        self.titleLabel.text = self.pageType
        self.timestampLabel.text = self.timestamp
        
        // safeArea
        let safeArea = self.view.safeAreaLayoutGuide
        
        // 측정 시간, 타이틀
        self.view.addSubview(headerStackView)
        headerStackView.addArrangedSubview(timestampLabel)
        headerStackView.addArrangedSubview(titleLabel)
        timestampLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor).isActive = true
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        headerStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        headerStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        headerStackView.widthAnchor.constraint(equalToConstant: graphViewWidth).isActive = true
        
        // 그래프 뷰
        self.view.addSubview(graphView)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 30).isActive = true
        graphView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: graphViewHeight).isActive = true
        graphView.widthAnchor.constraint(equalToConstant: graphViewWidth).isActive = true

        // 좌표값 display
        let offsetPannelStackView = graphViewMaker.OffsetPannelStackView
        graphView.addSubview(offsetPannelStackView)
        offsetPannelStackView.translatesAutoresizingMaskIntoConstraints = false
        offsetPannelStackView.topAnchor.constraint(equalTo: graphView.topAnchor, constant: 5).isActive = true
        offsetPannelStackView.centerXAnchor.constraint(equalTo: graphView.centerXAnchor).isActive = true
        offsetPannelStackView.widthAnchor.constraint(equalToConstant: graphViewWidth - 20).isActive = true
        
        if self.pageType == "Play" {
            // 재생, 정지, 기록시간
            self.view.addSubview(playPannelStackView)
            playPannelStackView.translatesAutoresizingMaskIntoConstraints = false
            playPannelStackView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20).isActive = true
            playPannelStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
            playPannelStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            playPannelStackView.widthAnchor.constraint(equalToConstant: graphViewWidth).isActive = true
            playPannelStackView.addArrangedSubview(invisibleBlock)
            playPannelStackView.addArrangedSubview(playButton)
            playPannelStackView.addArrangedSubview(stopButton)
            playPannelStackView.addArrangedSubview(timeLabel)
            invisibleBlock.widthAnchor.constraint(equalTo: playButton.widthAnchor).isActive = true
            invisibleBlock.widthAnchor.constraint(equalTo: stopButton.widthAnchor).isActive = true
            invisibleBlock.widthAnchor.constraint(equalTo: timeLabel.widthAnchor).isActive = true
            stopButton.isHidden = !graphViewMaker.isRunning
            playButton.isHidden = graphViewMaker.isRunning
        } else {
            // 전체 데이터 한번에
            graphViewMaker.play(animated: false)
        }
    }
    
    /**
        그래프 재생 상태를 변경
     */
    func changeStatus() {
        stopButton.isHidden = !graphViewMaker.isRunning
        playButton.isHidden = graphViewMaker.isRunning
    }
    
    /**
        재생 시작 버튼
     */
    @objc func playButtonPressed() {
        graphViewMaker.play(animated: true)
    }
    
    /**
        재생 중단 버튼
     */
    @objc func stopButtonPressed() {
        graphViewMaker.stop()
    }
    
    deinit {
        print("deinit")
    }

}

extension ReplayViewController: GraphViewMakerDelegate {
    func graphViewDidEnd() {
        // timer is invalidated
        changeStatus()
    }
    
    func graphViewDidPlay() {
        // timer is fire
        changeStatus()
    }
    
    func graphViewDidUpdate(interval: Float, x: Float, y: Float, z: Float) {
//        print("interval: \(interval)")
//        print("x: \(x) y: \(y) z: \(z)")
        timeLabel.text = String(format: "%0.1f", arguments: [interval])
    }
}
