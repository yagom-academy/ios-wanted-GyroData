//
//  ReviewPageView.swift
//  GyroData
//
//  Created by 맹선아 on 2023/02/01.
//

import UIKit

class ReviewPageView: UIView {
    
    private let pageState: PageState
    private let dateLabel = UILabel(font: .body)
    private let pageStateLabel = UILabel(font: .title1)
    private let timeLabel = UILabel(font: .title1, textAlignment: .right)
    private let lineGraphView = LineGraphView()
    private let PlayButton: UIButton = {
        let button = UIButton(frame: .zero)
        let playImage = UIImage(systemName: "play.fill")
        button.setBackgroundImage(playImage, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let graphStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 30)
    private let playStackView = UIStackView(distribution: .fill, alignment: .center)
    
    init(pageState: PageState) {
        self.pageState = pageState
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDateLabelText(_ text: String) {
        dateLabel.text = text
    }
    
    func setupPageStateLabelText(_ text: String) {
        pageStateLabel.text = text
    }
    
    func setupTimeLabelText(_ text: String) {
        timeLabel.text = text
    }
    
}

extension ReviewPageView {
    
    enum PageState {
        
        case resultView
        case resultPlay
        
        var pageName: String {
            switch self {
            case .resultView:
                return "View"
            case .resultPlay:
                return "Play"
            }
        }
    }
}

