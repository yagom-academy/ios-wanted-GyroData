//
//  FirstCellContentView.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import UIKit
import SwiftUI

class FirstCellContentView: UIView, FirstViewStyling {
    
    //input
    var didReceiveViewModel: (FirstCellContentViewModel) -> () = { viewModel in  }
    
    //properties
    var timeLabel: UILabel = UILabel()
    var measureTypeLabel: UILabel = UILabel()
    var amountLabel: UILabel = UILabel()
    
    var viewModel: FirstCellContentViewModel
    
    init(viewModel: FirstCellContentViewModel) {
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

extension FirstCellContentView: Presentable {
    func initViewHierarchy() {
        self.addSubview(timeLabel)
        self.addSubview(measureTypeLabel)
        self.addSubview(amountLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        measureTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        defer { NSLayoutConstraint.activate(constraints) }
        
        constraints += [
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: amountLabel.centerYAnchor)
        ]
        
        constraints += [
            measureTypeLabel.topAnchor.constraint(equalTo: amountLabel.centerYAnchor),
            measureTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            measureTypeLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),
            measureTypeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]
        
        constraints += [
            amountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            amountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ]
        
    }

    func configureView() {
        timeLabel.text = "2022/09/08 14:50:43"
        measureTypeLabel.text = "gyro"
        amountLabel.text = "60.0"
        
        timeLabel.addStyles(style: cellTimeLabelStyling)
        measureTypeLabel.addStyles(style: cellMeasureTypelabelStyling)
        amountLabel.addStyles(style: cellAmountTypeLabelStyling)
    }

    func bind() {
        didReceiveViewModel = { [weak self] viewModel in
            guard let self = self else { return }
            self.setData()
        }
    }
    
    private func setData() {
        timeLabel.text = viewModel.timeString
        measureTypeLabel.text = viewModel.measureTypeString
        amountLabel.text = viewModel.amountString
    }
}

#if canImport(SwiftUI) && DEBUG
struct FirstCellContentViewPreview<View: UIView> : UIViewRepresentable {
    
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
struct FirstCellContentViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        FirstCellContentViewPreview {
            let view = FirstCellContentView(viewModel: FirstCellContentViewModel())
            
            return view
        }.previewLayout(.fixed(width: 180, height: 80))
    }
}

#endif
