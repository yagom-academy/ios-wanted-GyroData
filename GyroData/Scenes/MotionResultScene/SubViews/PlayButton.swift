//
//  PlayButton.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/29.
//

import UIKit

class PlayButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        changesSelectionAsPrimaryAction = true
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)
        let selectedImage = UIImage(systemName: "stop.fill", withConfiguration: largeConfig)
        
        self.tintColor = .black
        
        setImage(image, for: .normal)
        setImage(selectedImage, for: .selected)
    }

}
