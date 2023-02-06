//
//  PlayButton.swift
//  GyroData
//
//  Created by Ayaan on 2023/02/03.
//

import UIKit

final class PlayButton: UIButton {
    enum Constant {
        static let playImageName = "play.fill"
        static let stopImageName = "stop.fill"
    }
    private var isActive: Bool = false {
        didSet { setImageOfActiveState() }
    }
    private var activeHandler: (() -> Void)?
    private var inactiveHandler: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        active()
        isActive.toggle()
    }
    
    func toggleAction() {
        isActive.toggle()
    }
    
    func setActiveHandler(_ activeHandler: @escaping () -> Void) {
        self.activeHandler = activeHandler
    }
    
    func setInactiveHandler(_ inactiveHandler: @escaping () -> Void) {
        self.inactiveHandler = inactiveHandler
    }
    
    private func setupUI() {
        setImageOfActiveState()
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        tintColor = .black
    }
    
    private func setImageOfActiveState() {
        let imageName = isActive ? Constant.stopImageName : Constant.playImageName
        setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func active() {
        isActive ? inactiveHandler?() : activeHandler?()
    }
}
