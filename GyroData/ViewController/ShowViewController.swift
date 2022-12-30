//
//  ShowViewController.swift
//  GyroData
//
//  Created by 천승희 on 2022/12/29.
//

import UIKit

enum ViewType: String {
    case preview = "View"
    case replay = "Play"
}

class ShowViewController: BaseViewController {
    // MARK: - View
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "2022/09/07 15:10:11"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = ViewType.replay.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [timeLabel, typeLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 5
            
            return stackView
        }()
    
    private lazy var graphView: GraphView = {
        let view = GraphView()
        
        return view
    }()
    
    private lazy var spaceView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(self.didTapPlayButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var playTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            spaceView, playButton, playTimeLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            labelStackView, graphView, hStackView
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        return stackView
    }()
    
    // MARK: - Properties
    private let viewTitle: String = "다시보기"
    var viewType: ViewType = .preview
    private var measureData: MeasureData?
    private var timer: Timer?
    private var playTime: Int = 0
    private var isPlay: Bool = false
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        constraints()
    }
}

// MARK: - ConfigureUI
extension ShowViewController {
    private func configureUI() {
        configureNavigationBar()
        checkViewType()
    }
    
    private func configureNavigationBar() {
        self.title = self.viewTitle
    }
    
    private func checkViewType() {
        if viewType == .preview {
            DispatchQueue.main.async {
                self.hStackView.isHidden = true
                self.typeLabel.text = ViewType.preview.rawValue
                self.drawGraph()
            }
        }
    }
    
    private func drawGraph() {
        guard let data = self.measureData else { return }
        var max = SensorType.acc.max
        if data.sensorType == SensorType.gyro.rawValue {
            max = SensorType.gyro.max
        }
        max += maxValueArr(x: data.xData ?? [], y: data.yData ?? [], z: data.zData ?? []) * 1.2
        self.graphView.isShow = true
        self.graphView.setShowGraphValue(x: data.xData ?? [],
                                         y: data.yData ?? [],
                                         z: data.zData ?? [],
                                         max: max,
                                         time: data.xData?.count ?? 0)
        self.graphView.setNeedsDisplay()
    }
}
// MARK: - Constraint
extension ShowViewController {
    private func constraints() {
        vStackViewConstraints()
        spaceViewConstraints()
        labelStackViewConstraints()
        graphViewConstraints()
        hStackViewConstraints()
        playTimeLabelConstraints()
    }
    
    private func vStackViewConstraints() {
        self.view.addSubview(vStackView)
        self.vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.vStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.vStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.vStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func spaceViewConstraints() {
        self.spaceView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.spaceView.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            self.spaceView.heightAnchor.constraint(equalTo: playButton.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func labelStackViewConstraints() {
        self.labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.labelStackView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
            self.labelStackView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func graphViewConstraints() {
        self.graphView.translatesAutoresizingMaskIntoConstraints = false

        let layout = [
            self.graphView.widthAnchor.constraint(equalTo: self.vStackView.widthAnchor),
            self.graphView.heightAnchor.constraint(equalTo: self.vStackView.widthAnchor)
        ]

        NSLayoutConstraint.activate(layout)
    }
    
    private func hStackViewConstraints() {
        self.hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = [
            self.hStackView.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
            self.hStackView.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
    
    private func playTimeLabelConstraints() {
        let layout = [
            self.playTimeLabel.widthAnchor.constraint(equalTo: self.playButton.widthAnchor),
            self.playTimeLabel.heightAnchor.constraint(equalTo: self.playButton.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(layout)
    }
}
// MARK: - Action
extension ShowViewController {
    @objc private func didTapPlayButton() {
        play()
    }
    
    private func play() {
        self.isPlay.toggle()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        if self.isPlay {
            self.playButton.setImage(UIImage(systemName: "stop.fill", withConfiguration: imageConfig), for: .normal)
            self.graphView.clear()
            self.graphView.measureTime = self.measureData?.xData?.count ?? 0
            
            var max = SensorType.acc.max
            if self.measureData?.sensorType == SensorType.gyro.rawValue {
                max = SensorType.gyro.max
            }
            self.graphView.setMax(max: max)
            
            self.timer = Timer(timeInterval: 0.1, repeats: true) { timer in
                self.playTimeLabel.text = String(format:"%4.1f",Double(self.playTime) / 10.0)
                
                if self.playTime >= self.measureData?.xData?.count ?? 0 {
                    self.timer?.invalidate()
                    
                    return
                }
                
                let (x, y, z) = self.decodeMeasureData(self.measureData, at: self.playTime)
                
                self.graphView.setLabel(x: x, y: y, z: z)
                self.graphView.getData(x: x, y: y, z: z)
                
                let regularExpression = abs(x) > max || abs(y) > max || abs(z) > max
                
                if regularExpression {
                    self.graphView.isOverflowValue = true
                    max += self.maxValue(x: x, y: y, z: z) * 0.2
                    self.graphView.setMax(max: max)
                }
                
                self.graphView.setNeedsDisplay()
                self.playTime += 1
            }
            if let timer = self.timer {
                RunLoop.current.add(timer, forMode: .default)
            }
        } else {
            self.playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: imageConfig), for: .normal)
            self.timer?.invalidate()
            self.playTime = 0
        }
    }
    
    private func setGraphViewMax() {
        
    }
}
// MARK: - Helper
extension ShowViewController {
    func decodeMeasureData(_ measureData: MeasureData?, at index:Int) -> (Double,Double,Double){
        if let measureData = measureData {
            if measureData.xData!.count != 0 && measureData.yData!.count != 0 && measureData.zData!.count != 0 {
                return (measureData.xData![index], measureData.yData![index], measureData.zData![index])
            }
        }

        timer?.invalidate()

        return (0.0, 0.0, 0.0)
    }
    
    func setMeasureData(data: MeasureData) {
        self.measureData = data
    }
    
    private func maxValueArr(x: [Double], y: [Double], z: [Double]) -> CGFloat {
        let xMax = x.max()!
        let yMax = y.max()!
        let zMax = z.max()!
        
        let arr = [xMax, yMax, zMax]
        
        return arr.max()!
    }
    
    private func maxValue(x: Double, y: Double, z: Double) -> Double {
        let arr = [x,y,z]
        return arr.max()!
    }
}
