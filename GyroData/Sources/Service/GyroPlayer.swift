//
//  GyroPlayer.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/15.
//

import Foundation
import Combine

final class GyroPlayer {
    enum Constant {
        static let interval = 0.1
    }
    
    private let originalGyroData: GyroData
    @Published private var playingGyroData: GyroData
    private var subscription: AnyCancellable?
    
    private var startIndex: Int
    private let endIndex: Int
    
    init(gyrodata: GyroData) {
        originalGyroData = gyrodata
        startIndex = gyrodata.coordinateList.startIndex
        endIndex = gyrodata.coordinateList.endIndex
        playingGyroData = gyrodata
        playingGyroData.coordinateList = []
        playingGyroData.duration = 0.0
    }
    
    func play() {
        bindToTimer()
    }
    
    func pause() {
        subscription?.cancel()
        subscription = nil
    }
    
    func playingGyroDataPublisher() -> AnyPublisher<GyroData, Never> {
        return $playingGyroData.eraseToAnyPublisher()
    }
    
    private func bindToTimer() {
        let interval = Constant.interval
        
        subscription = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let index = self?.startIndex,
                      let selectedData = self?.originalGyroData.coordinateList[safe: index] else {
                    self?.subscription?.cancel()
                    
                    return
                }
                
                self?.startIndex += 1
                self?.playingGyroData.add(selectedData, interval: interval)
            }
    }
}
