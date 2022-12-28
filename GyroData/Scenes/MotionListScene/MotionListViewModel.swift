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
    
    /// Output
    
    var items: Observable<[Motion]> = Observable([])
    var loading: Observable<Void> = Observable(())
    var error: Observable<String> = Observable("")
    
    /// Input
    
    func loadItems(count: Int) {
    }
    
    func deleteItem(motion: Motion) {
        // TODO: CoreData내 motionData 삭제 처리 로직
        if let index = items.value.firstIndex(where: { $0.id == motion.id }) {
            items.value.remove(at: index)
        }
    }
    
    func appendItems(count: Int) {
        
    }
    
}
