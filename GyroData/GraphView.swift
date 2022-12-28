//
//  GraphView.swift
//  GyroData
//
//  Created by Judy on 2022/12/27.
//

import UIKit

class GraphView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .systemBackground
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.drawGridGraph(in: self.bounds.size)
    }
}
