import Foundation

protocol MotionListViewModelInput {
    func loadItems()
    func deleteItem(information: MotionInformation)
}

protocol MotionListViewModelOutput {
    var items: Observable<[MotionInformation]> { get }
    var isloading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol MotionListViewModelType: MotionListViewModelInput, MotionListViewModelOutput { }

final class MotionListViewModel: MotionListViewModelType {
    let motionCoreDataUseCase = MotionCoreDataUseCase()
    
    var count = 10
    var offset = 0
    
    /// Output
    
    var items: Observable<[MotionInformation]> = Observable([])
    var isloading: Observable<Bool> = Observable(false)
    var error: Observable<String?> = Observable(nil)
    
    /// Input
    
    func loadItems() {
        offset = 0
        appendItems()
    }
    
    func deleteItem(information: MotionInformation) {
        motionCoreDataUseCase.delete(id: information.id) { result in
            switch result {
                case .success:
                    if let index = self.items.value.firstIndex(where: { $0.id == information.id }) {
                        self.items.value.remove(at: index)
                    }
                case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
        
    }
    
    func appendItems() {
        isloading.value = true
        DispatchQueue.global().async {
            guard let motionData = self.motionCoreDataUseCase.fetch(offset: self.offset, count: self.count) else { return }
            self.offset = self.count
            self.items.value = motionData
            self.isloading.value = false
        }
    }
    
}
