//
//  SecondViewSegementedControlView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit
import SwiftUI

class SecondViewSegementedControlView: UIView, SecondViewStyling {
    var segmentedControl: UISegmentedControl = UISegmentedControl()
    
    var viewModel: SecondSegmentViewModel
    
    init(viewModel: SecondSegmentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        initViewHierarchy()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SecondViewSegementedControlView: Presentable {
    func initViewHierarchy() {
        
        self.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            segmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
    }
    
    func configureView() {
        segmentedControl.addStyles(style: segmentControlStyling)
    }
    
    func bind() {
        viewModel.selectedTypeSource = { [weak self] type in
            if type == .acc {
                self?.segmentedControl.selectedSegmentIndex = 0
            } else {
                self?.segmentedControl.selectedSegmentIndex = 1
            }
        }
        
        viewModel.isUserInteractionEnabledSource = { [weak self] enabled in
            self?.segmentedControl.isUserInteractionEnabled = enabled
        }
    }
    
    @objc func segmentAction() {
        let type: MotionType = segmentedControl.selectedSegmentIndex == 0 ? .acc : .gyro
        viewModel.didSegmentChange(type)
    }
}

#if canImport(SwiftUI) && DEBUG
struct SecondViewSegementedControlViewPreview<View: UIView> : UIViewRepresentable {
    
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
struct SecondViewSegementedControlViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        FirstCellContentViewPreview {
            let view = SecondViewSegementedControlView(viewModel: SecondSegmentViewModel())
            
            return view
        }.previewLayout(.fixed(width: 180, height: 80))
    }
}

#endif
