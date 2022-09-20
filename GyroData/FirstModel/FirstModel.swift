//
//  FirstModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//
//testteesttest
import Foundation

class FirstModel {
    
    //input
    
    //output
    var contentViewModel: FirstListViewModel {
        return privateFirstListViewModel
    }
    
    var routeSubject: (SceneCategory) -> () = { sceneCategory in }
    
    //properties
    private var privateFirstListViewModel: FirstListViewModel
    private var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        self.privateFirstListViewModel = FirstListViewModel()
        bind()
    }
    
    private func bind() {
        privateFirstListViewModel.propergateDidSelectRowEvent = { [weak self] indexPathRow in
            //temp
            guard let self = self else { return }
            self.routeSubject(.detail(.secondViewController))
        }
    }
    
    func populateData() {
        
    }
}
