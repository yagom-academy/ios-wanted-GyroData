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
    
    var viewModel: FirstCellContentViewModel?
    
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
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ]
        
        constraints += [
            measureTypeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 6),
            measureTypeLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            measureTypeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ]
        
        constraints += [
            amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -21)
        ]
        
    }

    func configureView() {
        timeLabel.addStyles(style: cellTimeLabelStyling)
        measureTypeLabel.addStyles(style: cellMeasureTypelabelStyling)
        amountLabel.addStyles(style: cellAmountTypeLabelStyling)
    }

    func bind() {
        didReceiveViewModel = { [weak self] viewModel in
            guard let self = self else { return }
            self.viewModel = viewModel
            viewModel.timeSource = { time in
                self.timeLabel.text = time
            }
            viewModel.typeSource = { type in
                self.measureTypeLabel.text = type
            }
            viewModel.amountSource = { amount in
                self.amountLabel.text = amount
            }
        }
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
            let view = FirstCellContentView()
            view.didReceiveViewModel(FirstCellContentViewModel(DummyGenerator.getDummyMotionData()))
            return view
        }.previewLayout(.fixed(width: 390, height: 80))
    }
}

#endif
