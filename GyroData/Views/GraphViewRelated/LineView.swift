//
//  LineView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/27.
//

import UIKit

class LineView: UIView {
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

extension LineView: Presentable {
    func initViewHierarchy() {
        
    }
    
    func configureView() {
        self.backgroundColor = .black
    }
    
    func bind() {
        
    }
    
    
}
