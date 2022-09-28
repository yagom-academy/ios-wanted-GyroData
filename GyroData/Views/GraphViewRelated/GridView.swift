//
//  GridView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/27.
//

import UIKit
import SwiftUI

class GridView: UIView {

    var fixedWidth: CGFloat = 30.0
    var fixedHeight: CGFloat = 30.0
    
    var fixedWidthChecker: CGFloat = 0.0
    var fixedHeightChecker: CGFloat = 0.0
    
    var didDrawGridLines = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if didDrawGridLines == false {
            drawGridLines(rect: rect)
        }
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        bind()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridView: Presentable {
    
    func drawGridLines(rect: CGRect) {
        didDrawGridLines = true
        fixedWidth = rect.width / 10
        fixedHeight = rect.width / 10
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        //frame을 너무 일찍 가져와서 문제
        for i in 1..<10 {
            let verticalLine = LineView()
            verticalLine.alpha = 0.1
            verticalLine.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(verticalLine)
            
            constraint += [
                verticalLine.widthAnchor.constraint(equalToConstant: 1.0),
                verticalLine.topAnchor.constraint(equalTo: self.topAnchor),
                verticalLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                verticalLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: fixedWidth * CGFloat(i))
            ]
        }
        
        for i in 1..<10 {
            let horizontalLine = LineView()
            horizontalLine.alpha = i == 5 ? 0.8 : 0.1
            horizontalLine.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(horizontalLine)
            
            constraint += [
                horizontalLine.heightAnchor.constraint(equalToConstant: 1.0),
                horizontalLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                horizontalLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                horizontalLine.topAnchor.constraint(equalTo: self.topAnchor, constant: fixedHeight * CGFloat(i))
            ]
        }
    }
    
    func initViewHierarchy() {
        
    }
    
    func configureView() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
    
    func bind() {
        
    }
    
    
}

#if canImport(SwiftUI) && DEBUG
struct GridViewPreview<View: UIView> : UIViewRepresentable {
    
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

#endif

#if canImport(SwiftUI) && DEBUG
struct GridViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        GridViewPreview {
            let view = GridView()
            return view
        }.previewLayout(.fixed(width: 390, height: 720))
    }
}

#endif
