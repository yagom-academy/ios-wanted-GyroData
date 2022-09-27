//
//  GridView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/27.
//

import UIKit
import SwiftUI

class GridView: UIView {
    //칸 하나의 사이즈는 대략 10 x 10?
    //for로 가로선 쭉쭉 만들고
    //for로 세로선 쭉쭉 만들고
    lazy var width = self.frame.width
    lazy var height = self.frame.height
    let fixedWidth: CGFloat = 10.0
    let fixedHeight: CGFloat = 10.0
    
    var fixedWidthChecker: CGFloat = 0.0
    var fixedHeightChecker: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        print("draw called")
        
    }
    
    init() {
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridView: Presentable {
    
    func initViewHierarchy() {
        
        print("initViewHierachy")
        var constraint: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraint) }
        
        print("width check heicht check : \(width) \(height)")
        //frame을 너무 일찍 가져와서 문제
        while 180 > fixedWidthChecker {
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
            print("width called")
        }
        
        //frame을 너무 일찍 가져와서 문제
        while 360 > fixedHeightChecker {
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
            print("height called")
        }
        
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
        FirstCellContentViewPreview {
            let view = GridView()
            return view
        }.previewLayout(.fixed(width: 390, height: 80))
    }
}

#endif
