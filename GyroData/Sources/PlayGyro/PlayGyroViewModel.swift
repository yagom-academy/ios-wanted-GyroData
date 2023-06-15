//
//  PlayGyroViewModel.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

import Foundation
import Combine

final class PlayGyroViewModel {
    private let gyroPlayer: GyroPlayer
    
    init(gyrodata: GyroData) {
        gyroPlayer = GyroPlayer(gyrodata: gyrodata)
    }
    
    func play() {
        gyroPlayer.play()
    }
    
    func pause() {
        gyroPlayer.pause()
    }
    
    func playingGyroDataPublisher() -> AnyPublisher<GyroData, Never> {
        return gyroPlayer.playingGyroDataPublisher()
    }
}
