//
//  GridView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/27.
//

import UIKit
import SwiftUI

class GridView: UIView {

    let fixedWidth: CGFloat = 30.0
    let fixedHeight: CGFloat = 30.0
    
    var fixedWidthChecker: CGFloat = 0.0
    var fixedHeightChecker: CGFloat = 0.0
    
    var didDrawGridLines = false
    
    override func draw(_ rect: CGRect) {
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
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        //frame을 너무 일찍 가져와서 문제
        while rect.width > fixedWidthChecker {
            fixedWidthChecker += fixedWidth
            let verticalLine = LineView()
            verticalLine.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(verticalLine)
            
            constraint += [
                verticalLine.widthAnchor.constraint(equalToConstant: 1.0),
                verticalLine.topAnchor.constraint(equalTo: self.topAnchor),
                verticalLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                verticalLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: fixedWidthChecker)
            ]
        }
        
        //frame을 너무 일찍 가져와서 문제
        while rect.height > fixedHeightChecker {
            fixedHeightChecker += fixedHeight
            let horizontalLine = LineView()
            horizontalLine.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(horizontalLine)
            
            constraint += [
                horizontalLine.heightAnchor.constraint(equalToConstant: 1.0),
                horizontalLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                horizontalLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                horizontalLine.topAnchor.constraint(equalTo: self.topAnchor, constant: fixedHeightChecker)
            ]
        }
    }
    
    func initViewHierarchy() {
        
    }
    
    func configureView() {
        self.backgroundColor = .white
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
