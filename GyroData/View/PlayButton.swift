//
//  PlayButton.swift
//  GyroData
//
//  Created by 리지 on 2023/06/15.
//

import UIKit

final class PlayButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 80, weight: .medium)
        self.setImage(UIImage(systemName: "play.fill", withConfiguration: configuration), for: .normal)
        self.tintColor = .black
    }
}
