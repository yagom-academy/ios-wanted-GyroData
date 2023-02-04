//
//  GraphView.swift
//  GyroData
//
//  Created by Kyo, JPush on 2023/02/02.
//

import UIKit

final class GraphView: UIView {
    typealias Values = (x: Double, y: Double, z: Double)
    typealias Positions = (x: Double, y: Double, z: Double)
    
    enum Constant {
        static let scale = Double(5)
        static let graphLineWidth = CGFloat(0.7)
    }
    
    enum Segment {
        case x
        case y
        case z
        
        var color: UIColor {
            switch self {
            case .x:
                return .systemRed
            case .y:
                return .systemGreen
            case .z:
                return .systemBlue
            }
        }
    }
    
    private var segmentValues: [Values] = []
    private let segmentOffset: Double
    
    private let interval: TimeInterval
    private let duration: TimeInterval
    
    private var scale: Double
    
    private var timer: Timer?
    private var timerIntervalPoint = 0 {
        didSet {
            timerHandler?(Double(timerIntervalPoint) / 10.0)
        }
    }
    
    private var timerHandler: ((TimeInterval) -> Void)?
    
    weak var playDelegate: GraphViewPlayDelegate?
    
    func timeIntervalBind(handler: ((TimeInterval) -> Void)?) {
        timerHandler = handler
    }
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.textColor = Segment.x.color
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.text = "x : 0"
        
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.textColor = Segment.y.color
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.text = "y : 0"
        return label
    }()
    
    private let zLabel: UILabel = {
        let label = UILabel()
        label.textColor = Segment.z.color
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.text = "z : 0"
        return label
    }()
    
    init(interval: TimeInterval, duration: TimeInterval) {
        self.interval = interval
        self.duration = duration
        self.segmentOffset = duration / interval
        self.scale = Constant.scale
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupBaseLine()
        self.bringSubviewToFront(labelStackView)
    }
    
    func dataInit() {
        segmentValues = []
        scale = Constant.scale
        initView()
    }
    
    func drawData(data: Values) {
        if isOverScale(data) {
            reDrawEntireData()
        }
        
        let xlayer = CAShapeLayer()
        let ylayer = CAShapeLayer()
        let zlayer = CAShapeLayer()
        
        let xPath = UIBezierPath()
        let yPath = UIBezierPath()
        let zPath = UIBezierPath()
        
        let lastValues = segmentValues.last ?? (.zero, .zero, .zero)
        let widthInterval = self.frame.width / segmentOffset
        
        let lastPosition = (Double(segmentValues.count) * widthInterval)
        
        let convertedValues = mappingValuesToFrame(values: lastValues)
        let convertedNewValues = mappingValuesToFrame(values: data)
        
        let xStartPoint = CGPoint(x: lastPosition, y: convertedValues.x)
        let xEndPoint = CGPoint(x: lastPosition + widthInterval, y: convertedNewValues.x)
        
        let yStartPoint = CGPoint(x: lastPosition, y: convertedValues.y)
        let yEndPoint = CGPoint(x: lastPosition + widthInterval, y: convertedNewValues.y)
        
        let zStartPoint = CGPoint(x: lastPosition, y: convertedValues.z)
        let zEndPoint = CGPoint(x: lastPosition + widthInterval, y: convertedNewValues.z)
        
        xPath.move(to: xStartPoint)
        xPath.addLine(to: xEndPoint)

        yPath.move(to: yStartPoint)
        yPath.addLine(to: yEndPoint)
        
        zPath.move(to: zStartPoint)
        zPath.addLine(to: zEndPoint)
        
        xlayer.strokeColor = Segment.x.color.cgColor
        xlayer.lineWidth = Constant.graphLineWidth
        xlayer.path = xPath.cgPath
        
        ylayer.strokeColor = Segment.y.color.cgColor
        ylayer.lineWidth = Constant.graphLineWidth
        ylayer.path = yPath.cgPath
        
        zlayer.strokeColor = Segment.z.color.cgColor
        zlayer.lineWidth = Constant.graphLineWidth
        zlayer.path = zPath.cgPath
        
        self.layer.addSublayer(xlayer)
        self.layer.addSublayer(ylayer)
        self.layer.addSublayer(zlayer)
        
        self.xLabel.text = "x: \(Double(round(1000 * data.x) / 1000))"
        self.yLabel.text = "y: \(Double(round(1000 * data.y) / 1000))"
        self.zLabel.text = "z: \(Double(round(1000 * data.z) / 1000))"
        
        segmentValues.append(data)
    }
    
    func setEntrieData(data: [Values]) {
        self.segmentValues = data
    }
    
    func drawEntireData() {
        reDrawEntireData()
    }
    
    func playEntireDataFlow() {
        let entireData = segmentValues
        timerIntervalPoint = .zero
        initView()
        
        timer = Timer(timeInterval: interval, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            let data = entireData[self.timerIntervalPoint]
            
            self.drawData(data: data)
            self.timerIntervalPoint += 1
            
            if entireData.count <= self.segmentValues.count {
                timer.invalidate()
                self.timer = nil
                self.playDelegate?.endPlayingGraphView()
                
            }
        })
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    func stopEntireDataFlow() {
        timer?.invalidate()
        timer = nil
        self.timerIntervalPoint = .zero
    }
    
}

private extension GraphView {
    func setupStackView() {
        self.addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:  8),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
        
        [xLabel, yLabel, zLabel].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    func initView() {
        layer.sublayers = [layer.sublayers![.zero]]
        segmentValues = []
        setupStackView()
    }
    
    func setupBaseLine() {
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        
        let lineCount = 8
        let xOffset = self.frame.width / CGFloat(lineCount)
        let yOffset = self.frame.height / CGFloat(lineCount)
        var xpointer: CGFloat = .zero
        var ypointer: CGFloat = .zero
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.systemGray2.cgColor
        
        Array(1...lineCount).forEach { _ in
            xpointer += xOffset
            path.move(to: CGPoint(x: xpointer, y: .zero))
            let newXPosition = CGPoint(x: xpointer, y: height)
            path.addLine(to: newXPosition)
            
            ypointer += yOffset
            path.move(to: CGPoint(x: .zero, y: ypointer))
            let newYPosition = CGPoint(x: width, y: ypointer)
            path.addLine(to: newYPosition)
        }
        
        layer.fillColor = UIColor.gray.cgColor
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 1
        layer.path = path.cgPath
        
        self.layer.addSublayer(layer)
    }
    
    func mappingValuesToFrame(values: Values) -> Values {
        let mappingValues = [values.x, values.y, values.z].map {
            let mappingValue = $0 / (scale * 2)
            let positionFromFrame = self.frame.height * (0.5 - mappingValue)
            
            return positionFromFrame
        }
        
        return (mappingValues[.zero], mappingValues[1], mappingValues[2])
    }
    
    func isOverScale(_ data: Values) -> Bool {
        let maxValue = [data.x, data.y, data.z].map({ abs($0) }).max() ?? scale
        
        if maxValue > scale {
            adjustScale(maxValue)
            return true
        } else {
            return false
        }
    }
    
    func adjustScale(_ scale: Double) {
        self.scale = self.scale + scale * 0.2
    }
    
    func reDrawEntireData() {
        let entireData = segmentValues
        
        initView()
        
        entireData.forEach {
            drawData(data: $0)
        }
    }
}
