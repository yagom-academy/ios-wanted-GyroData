//
//  GraphView.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/13.
//

import UIKit
import Combine

class GraphView: UIView {
    private let xLabel = {
        let label = UILabel()
        label.text = "testing"
        
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let yLabel = {
        let label = UILabel()
        label.text = "testing"

        label.textAlignment = .center
        label.textColor = .systemGreen
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let zLabel = {
        let label = UILabel()
        label.text = "testing"

        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let viewModel: RecordGyroViewModel
    private var gyroData: GyroData?
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: RecordGyroViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupView()
        drawGrid()
        drawGraph()
    }
    
    private func drawGrid() {
        let row = 8
        let column = 8
        let width = bounds.width * 0.95
        let height = bounds.height * 0.95
        let unitWidth = width / CGFloat(column)
        let unitHeight = height / CGFloat(row)
        let startPoint = CGPoint(x: (bounds.width - width) / 2.0,
                                 y: (bounds.height - height) / 2.0)
        
        let path = UIBezierPath()

        for count in 0...row {
            let y = startPoint.y + (unitHeight * CGFloat(count))
            
            path.move(to: CGPoint(x: startPoint.x, y: y))
            path.addLine(to: CGPoint(x: startPoint.x + width, y: y))
        }
        
        for count in 0...column {
            let x = startPoint.x + (unitWidth * CGFloat(count))
            
            path.move(to: CGPoint(x: x, y: startPoint.y))
            path.addLine(to: CGPoint(x: x, y: startPoint.y + height))
        }
        
        UIColor.black.setStroke()
        path.lineWidth = 0.3
        path.stroke()
    }
    
    private func drawGraph() {
        guard var gyroData else { return }
        
        let width = bounds.width * 0.95
        let unitWidth = width / (GyroRecorder.Constant.frequency * 60.0)
        
        var x = (bounds.width - width) / 2.0
        let y = bounds.height / 2.0
        
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        pathX.move(to: CGPoint(x: x, y: y))
        pathY.move(to: CGPoint(x: x, y: y))
        pathZ.move(to: CGPoint(x: x, y: y))
        
        while let coordinate = gyroData.dequeue() {
            pathX.addLine(to: CGPoint(x: x, y: y - (coordinate.x * 100)))
            pathY.addLine(to: CGPoint(x: x, y: y - (coordinate.y * 100)))
            pathZ.addLine(to: CGPoint(x: x, y: y - (coordinate.z * 100)))
            
            x += unitWidth
        }
        
        UIColor.systemRed.setStroke()
        pathX.lineWidth = 1
        pathX.lineJoinStyle = .bevel
        pathX.stroke()
        
        UIColor.systemGreen.setStroke()
        pathY.lineWidth = 1
        pathY.lineJoinStyle = .bevel
        pathY.stroke()
        
        UIColor.systemBlue.setStroke()
        pathZ.lineWidth = 1
        pathZ.lineJoinStyle = .bevel
        pathZ.stroke()
    }
    
    private func drawEachPoint(_ coordinate: Coordinate) {
        
    }
    
    private func setupView() {
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(xLabel)
        addSubview(yLabel)
        addSubview(zLabel)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            xLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 20),
            xLabel.trailingAnchor.constraint(equalTo: yLabel.leadingAnchor, constant: -20),
            xLabel.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.2),
            
            yLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 20),
            yLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            yLabel.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.2),
            
            zLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 20),
            zLabel.leadingAnchor.constraint(equalTo: yLabel.trailingAnchor, constant: 20),
            zLabel.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.2),
        ])
    }
    
    private func bind() {
        viewModel.gyroDataPublisher()
            .sink { [weak self] gyroData in
                self?.gyroData = gyroData
                self?.configureLabel()
                self?.setNeedsDisplay()
            }
            .store(in: &subscriptions)
    }
    
    private func configureLabel() {
        guard let gyroData = gyroData?.readLastGyroData() else { return }
        
        let formattedX = String(format: "%.2f", gyroData.x)
        let formattedY = String(format: "%.2f", gyroData.y)
        let formattedZ = String(format: "%.2f", gyroData.z)
        
        xLabel.text = "x: \(formattedX)"
        yLabel.text = "y: \(formattedY)"
        zLabel.text = "z: \(formattedZ)"
    }
}
