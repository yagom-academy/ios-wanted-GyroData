//
//  GraphView.swift
//  GyroData
//
//  Created by minsson on 2022/12/27.
//

import UIKit

protocol GraphDrawable {
    var data: MeasuredData? { get }
    
    func retrieveData(data: MeasuredData?)
    func startDraw()
    func stopDraw()
    
}

protocol TickReceivable {
    func receive(x: Double, y: Double, z: Double)
}

final class GraphView: UIView, TickReceivable {
    var data: MeasuredData?
    
    func receive(x: Double, y: Double, z: Double) {

    }
    
    func retrieveData(data: MeasuredData?) {
        self.data = data
    }
}

final class GraphContainerView: UIView {
    private enum Configuration {
        static let borderWidth: CGFloat = 4
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupRootView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GraphContainerView {
    func setupRootView() {
        self.backgroundColor = .clear
        self.layer.borderWidth = Configuration.borderWidth
    }
}
