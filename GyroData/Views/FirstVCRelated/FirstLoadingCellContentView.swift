//
//  FirstLoadingCellContentView.swift
//  GyroData
//
//  Created by channy on 2022/09/26.
//

import UIKit
import SwiftUI

class FirstLoadingCellContentView: UIView, FirstViewStyling {
    
    //input
    var didReceiveViewModel: (FirstLoadingCellContentViewModel) -> () = { viewModel in  }
    
    //properties
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var viewModel: FirstLoadingCellContentViewModel?
    
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

extension FirstLoadingCellContentView: Presentable {
    func initViewHierarchy() {
        self.addSubview(activityIndicatorView)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        
    }

    func configureView() {
        activityIndicatorView.addStyles(style: cellActivityIndicatorViewStyling)
    }

    func bind() {
        didReceiveViewModel = { [weak self] viewModel in
            guard let self = self else { return }
            self.viewModel = viewModel
        }
    }
}

#if canImport(SwiftUI) && DEBUG
struct FirstLoadingCellContentViewPreview<View: UIView> : UIViewRepresentable {
    
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
struct FirstLoadingCellContentViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        FirstLoadingCellContentViewPreview {
            let view = FirstLoadingCellContentView()
            view.didReceiveViewModel(FirstLoadingCellContentViewModel())
            return view
        }.previewLayout(.fixed(width: 390, height: 80))
    }
}

#endif
