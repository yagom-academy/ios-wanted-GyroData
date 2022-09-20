//
//  FirstModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

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
            let repository = Repository()
            let model = SecondModel(repository: repository)
            let sceneContext = SceneContext(dependency: model)
            self.routeSubject(.detail(.secondViewController(context: sceneContext)))
        }
    }
    
    func populateData() {
        
    }
}
