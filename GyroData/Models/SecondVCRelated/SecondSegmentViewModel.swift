//
//  SecondSegmentViewModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class SecondSegmentViewModel {
    // MARK: Input
    var didSegmentChange: (String) -> () = { type in }
    
    // MARK: Output
    // 이 클로저는 View Binding에만 사용하는 중입니다.
    // SecondVC에서 "저장" 버튼을 눌렀을 때 SecondModel에서 CoreData와 FileManager 저장을 진행하는데,
    // SecondVC가 selectedType의 값을 어떻게 가져갈 지 고민중입니다. Rx..?
    var selectedTypeSource: (String) -> () = { type in } {
        didSet {
            selectedTypeSource(_selectedType)
        }
    }
    
    // MARK: Properties
    private var _selectedType: String
    
    init() {
        _selectedType = "ACC"
        bind()
    }
    
    private func bind() {
        didSegmentChange = { [weak self] type in
            guard let self = self else { return }
            self._selectedType = type
        }
    }
}
