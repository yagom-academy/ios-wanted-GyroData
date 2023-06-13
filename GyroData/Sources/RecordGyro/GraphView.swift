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
        
        label.textAlignment = .center
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let yLabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .systemGreen
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let zLabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: 삭제 필요
    private lazy var countLabel = {
        let label = UILabel()
        
        label.text = "testing"
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        label.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.2).isActive = true
        
        return label
    }()
    
    private let viewModel: RecordGyroViewModel
    private var gyroData: GyroData?
    private var subscriptions = Set<AnyCancellable>()
    
    private var drawSectionHeight: Double {
        bounds.height * 0.95
    }
    private var drawSectionWidth: Double {
        bounds.width * 0.95
    }
    private var maximumY = 0.5
    private var scaleY: Double {
        drawSectionHeight / (maximumY * 2)
    }

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
        let offsetX = drawSectionWidth / CGFloat(column)
        let offsetY = drawSectionHeight / CGFloat(row)
        let startPoint = CGPoint(x: (bounds.width - drawSectionWidth) / 2.0,
                                 y: (bounds.height - drawSectionHeight) / 2.0)
        let x = (bounds.width - drawSectionWidth) / 2.0
        let y = (bounds.height - drawSectionHeight) / 2.0
        
        let path = UIBezierPath()

        for count in 0...row {
            path.move(to: CGPoint(x: x, y: y + (offsetY * CGFloat(count))))
            path.addLine(to: CGPoint(x: x + drawSectionWidth, y: y + (offsetY * CGFloat(count))))
        }
        
        for count in 0...column {
            path.move(to: CGPoint(x: x + (offsetX * CGFloat(count)), y: y))
            path.addLine(to: CGPoint(x: x + (offsetX * CGFloat(count)), y: y + drawSectionHeight))
        }
        
        UIColor.black.setStroke()
        path.lineWidth = 0.3
        path.stroke()
    }
    
    private func drawGraph() {
        guard var gyroData,
              gyroData.count > 1 else { return }
        
        let offsetX = drawSectionWidth / (Double(gyroData.count) - 1)
        countLabel.text = String(gyroData.count)
        var x = (bounds.width - drawSectionWidth) / 2.0
        let y = bounds.height / 2.0
        
        let pathX = UIBezierPath()
        let pathY = UIBezierPath()
        let pathZ = UIBezierPath()
        
        if let coordinate = gyroData.dequeue() {
            checkMaximumValue(coordinate.x, coordinate.y, coordinate.z)
            
            pathX.move(to: CGPoint(x: x, y: y - (coordinate.x * scaleY)))
            pathY.move(to: CGPoint(x: x, y: y - (coordinate.y * scaleY)))
            pathZ.move(to: CGPoint(x: x, y: y - (coordinate.z * scaleY)))
        }
        
        while let coordinate = gyroData.dequeue() {
            checkMaximumValue(coordinate.x, coordinate.y, coordinate.z)
            
            x += offsetX
            pathX.addLine(to: CGPoint(x: x, y: y - (coordinate.x * scaleY)))
            pathY.addLine(to: CGPoint(x: x, y: y - (coordinate.y * scaleY)))
            pathZ.addLine(to: CGPoint(x: x, y: y - (coordinate.z * scaleY)))
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
    
    private func checkMaximumValue(_ x: Double, _ y: Double, _ z: Double) {
        guard let maximumValue = [maximumY, abs(x), abs(y), abs(z)].max() else { return }
        
        if maximumValue > maximumY {
            maximumY = maximumValue * 1.2
        }
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
