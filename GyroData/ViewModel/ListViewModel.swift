//
//  ListViewModel.swift
//  GyroData
//
//  Created by ash and som on 2023/01/31.
//

import UIKit

// TODO: input-output 정리
protocol ListInput {
    var isLoading: Observable<Bool> { get }
    mutating func fetchGyroInformations(limit: Int)
    func deleteGyroInformation(_ info: GyroInformationModel)
}

protocol ListOutput {
    var gyroInformations: Observable<[GyroInformationModel]> { get set }
    var numberOfSections: Int { get set }
    var numberOfRowsInSection: Observable<Int> { get set }
    var error: Observable<String?> { get }
}

struct ListViewModel: ListInput, ListOutput {
    private let coreDataManager = CoreDataManager.shared
    var gyroInformations: Observable<[GyroInformationModel]> = Observable(value: [])
    var isLoading: Observable<Bool> = Observable(value: false)
    var numberOfSections: Int = 1
    var numberOfRowsInSection: Observable<Int> = Observable(value: 10)
    var error: Observable<String?> = Observable(value: nil)
    
    init() {
        fetchGyroInformations(limit: 10)
    }
    
    mutating func fetchGyroInformations(limit: Int) {
        self.isLoading.value = true
        
        do {
            guard let gyroInformations = try? coreDataManager.fetch(limit: limit) else {
                throw CoreDataError.fetchFailure
            }
            
            self.gyroInformations.value = gyroInformations
        } catch {
            print(error.localizedDescription)
        }
        
        self.isLoading.value = false
    }
    
    func deleteGyroInformation(_ info: GyroInformationModel) {
        coreDataManager.delete(info) { result in
            switch result {
            case .success:
                guard let index = gyroInformations.value?.firstIndex(where: {$0.id == info.id}) else { return }
                gyroInformations.value?.remove(at: index)
            case .failure(let failure):
                self.error.value = failure.message
            }
        }
    }
}
