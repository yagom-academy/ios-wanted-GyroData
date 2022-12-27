//
//  MotionListViewModel.swift
//  GyroData
//
//  Created by 이호영 on 2022/12/27.
//

import Foundation

protocol MotionListViewModelInput {
    func loadItems(count: Int)
    func deleteItem(motion: Motion)
    func appendItems(count: Int)
}

protocol MotionListViewModelOutput {
    var items: Observable<[Motion]> { get }
    var loading: Observable<Void> { get }
    var error: Observable<String> { get }
}

protocol MotionListViewModelType: MotionListViewModelInput, MotionListViewModelOutput { }

class MotionListViewModel: MotionListViewModelType {
    
    var items: Observable<[Motion]> = Observable([])
    var loading: Observable<Void> = Observable(())
    var error: Observable<String> = Observable("")
    
    func loadItems(count: Int) {
        
    }
    
    func deleteItem(motion: Motion) {
        
    }
    
    func appendItems(count: Int) {
        
    }
    
    
}
