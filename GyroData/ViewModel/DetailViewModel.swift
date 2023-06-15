//
//  DetailViewModel.swift
//  GyroData
//
//  Created by 리지 on 2023/06/14.
//

import Foundation
import Combine

final class DetailViewModel {
    @Published private(set) var currentData: GyroEntity?
    @Published var timerLabel: String = "00.0"
    
    let timerModel: TimerModel
    private var cancellables = Set<AnyCancellable>()
    
    init(timerViewModel: TimerModel) {
        self.timerModel = timerViewModel
        bindTimer()
    }

    private func bindTimer() {
        timerModel.$tenthOfaSeconds
            .sink(receiveValue: { [weak self] double in
                guard let convertedTime = self?.numberFormatter.string(from: NSNumber(value: double)) else { return }
                self?.timerLabel = convertedTime
            })
            .store(in: &cancellables)
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        return dateFormatter
    }()
    
    private func decodeJSONFile(at url: URL) -> SixAxisDataForJSON? {
        do {
            let jsonData = try Data(contentsOf: url)
            let jsonDecoder = JSONDecoder()
            let decodeData = try jsonDecoder.decode(SixAxisDataForJSON.self, from: jsonData)
            return decodeData
        } catch {
            print("디코딩실패 \(error.localizedDescription)")
            return nil
        }
    }
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        
        return numberFormatter
    }()
}

extension DetailViewModel {
    var date: String? {
        guard let currentData = currentData,
              let date = currentData.date else { return nil }
        
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }

    func addData(_ data: GyroEntity) {
        currentData = data
    }
    
    func fetchData(by id: UUID) -> SixAxisDataForJSON? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "\(id).json"
        let fileURL = documentDirectory.appendingPathComponent("GyroData폴더").appendingPathComponent(fileName)
        return decodeJSONFile(at: fileURL)
    }
    
}
