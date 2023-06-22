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
        setUpPlayMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPlayMode() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        self.setImage(UIImage(systemName: "play.fill", withConfiguration: configuration), for: .normal)
        self.tintColor = .black
    }
    
    func setUpStopMode() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        self.setImage(UIImage(systemName: "stop.fill", withConfiguration: configuration), for: .normal)
    }
}
