//
//  FirstModel.swift
//  GyroData
//
//  Created by pablo.jee on 2022/09/20.
//

import Foundation

class FirstModel: SceneActionReceiver {
    //input
    var didTapMeasureButton: (() -> ()) = { }
    var didReceiveSceneAction: (SceneAction) -> () = { action in }
    
    //output
    var contentViewModel: FirstListViewModel {
        return privateFirstListViewModel
    }
    
    var routeSubject: (SceneCategory) -> () = { sceneCategory in }
    
    //properties
    private var privateFirstListViewModel: FirstListViewModel
    private var repository: RepositoryProtocol
    var motionTasks = [MotionTask]()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
        // MARK: - Core Data 테스트 데이터
//        Task {
//            for _ in 0..<10 {
//                do {
//                    try await DummyGenerator.insertDummyMotionDataToCoreData()
//                } catch {
//                    throw error
//                }
//            }
//        }

        // MARK: - FileManager 테스트 데이터, 파일 이름은 yyyy-MM-dd-hh-mm-ss 을 string 인자로 받음.
//        Task {
//            try await repository.saveToFileManager(file:DummyGenerator.getDummyMotionFile())
//        }
//        Task {
//            let result = try await FileManager.default.loadMotionFile(name: "2022-09-27-14-24-29")
//            print(result)
//        }
//
        
        // -----
        self.privateFirstListViewModel = FirstListViewModel(motionTasks)
        bind()
    }
    
    private func bind() {
        didTapMeasureButton = { [weak self] in
            guard let self else { return }
            let repository = Repository()
            let motionManager = CoreMotionManager()
            let model = SecondModel(repository: repository, motionManager: motionManager)
            let sceneContext = SceneContext(dependency: model)
            self.routeSubject(.detail(.secondViewController(context: sceneContext)))
        }
        privateFirstListViewModel.propagateDidSelectRowEvent = { [weak self] motion in
            guard let self = self else { return }
            let model = ThirdModel(repository: self.repository, viewType: .view, motion: motion)
            let context = SceneContext(dependency: model)
            self.routeSubject(.detail(.thirdViewController(context: context)))
        }
        privateFirstListViewModel.propagateDidSelectPlayActionEvent = { [weak self] motion in
            guard let self = self else { return }
            let model = ThirdModel(repository: self.repository, viewType: .play, motion: motion)
            let context = SceneContext(dependency: model)
            self.routeSubject(.detail(.thirdViewController(context: context)))
        }
        privateFirstListViewModel.propagateStartPaging = { [weak self] _ in
            guard let self = self else { return }
            print("!!!!!!!")
            self.populateData()
        }
        
        didReceiveSceneAction = { [weak self] action in
            guard let action = action as? FirstSceneAction else { return }
            guard let self else { return }
            switch action {
            case .refresh:
                self.populateData()
            }
        }
    }
    
    func populateData() {
        Task {
            let motionTasks = try await self.repository.fetchFromCoreData()
            privateFirstListViewModel.didReceiveMotionTasks(motionTasks)
        }
    }
}
