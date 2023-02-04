# Gyro 기록기
- 핸드폰에 있는 가속도계와 자이로스코프 측정을 하고 기록하는 앱

## 🌱 팀 소개
 |[미니](https://github.com/leegyoungmin)|[Mangdi](https://github.com/MangDi-L)|
 |:---:|:---:|
|<a href="https://github.com/leegyoungmin"><img height="150" src="https://i.imgur.com/pcJY2Gn.jpg"></a>|<a href="https://github.com/MangDi-L"><img height="150" src="https://avatars.githubusercontent.com/u/49121469"></a>|

### 개발 파트
#### 미니
- 데이터를 측정하고 저장하기
- 저장된 데이터를 불러와서 재생하기
- 측정되는 데이터를 그래프로 그리기

#### Mangdi
- 저장된 메타데이터를 읽고, 리스트 구현
- 측정된 데이터를 그래프로 그리기
- 코어 데이터 관리 객체


## 💾 개발환경 및 라이브러리
![Badge](https://img.shields.io/badge/UIKit-UI_Configure-informational?style=for-the-badge&logo=Swift&logoColor=white)

![Badge4](https://img.shields.io/badge/MVC-Architecture-success?style=for-the-badge)

![Badge2](https://img.shields.io/badge/Core_Data-Local_DataBase-yellow?style=for-the-badge)

## 🛠 기능 소개
- 가속도계와 자이로스코프에 대한 기록을 합니다.
- 기록된 데이터를 CoreData 및 FileManager를 통해 저장합니다.
- CoreData 및 FileManager로 데이터를 읽어옵니다.
- 기록된 데이터를 그래프와 함께 재생할 수 있습니다.


| 기능 화면 | 삭제 기능 및 스크롤|다크 모드|
| :--------: | :--------: | :--------: |
| <img width="500" src="https://i.imgur.com/z9Ukxp5.gif"> |<img width="500" src="https://i.imgur.com/2OLtZlD.gif">|<img width="500" src="https://i.imgur.com/SVYtcQz.gif">|


## 👀 Diagram
### 1. View 구조
![](https://i.imgur.com/4zBQoEG.jpg)

### 2. Delegate 구조
![](https://i.imgur.com/6zr1jNj.jpg)

## 🗂 폴더 구조
```bash!
.
├── Controller
│   ├── PlayViewController.swift
│   ├── RecordViewController.swift
│   └── TransitionListViewController.swift
├── Extensions
│   ├── Date+Extension.swift
│   └── UIFont+Extension.swift
├── Model
│   ├── CoreData
│   │   ├── PersistentContainerManager.swift
│   │   ├── TransitionMetaDataObject+CoreDataClass.swift
│   │   └── TransitionMetaDataObject+CoreDataProperties.swift
│   ├── Delegate
│   │   └── GraphDelegate.swift
│   ├── Motion
│   │   └── MotionManager.swift
│   ├── SystemFile
│   │   ├── SystemFileError.swift
│   │   └── SystemFileManager.swift
│   ├── Transition
│   │   ├── Sensor.swift
│   │   ├── Transition.swift
│   │   └── TransitionMetaData.swift
│   └── Upload
│       ├── UploadError.swift
│       └── Uploadable.swift
├── Utility
│   └── AlertBuilder.swift
└── View
    ├── GraphView.swift
    └── TransitionListCell.swift
```

## 🕰️ 타임라인
|날짜|구현 내용|
|--|--| 
|23.01.30|프로젝트 기본 설정, 데이터 구조 및 흐름 구성|
|22.01.31|리스트 화면 틀 구현, 측정 화면 틀 구현|
|22.02.01|코어 데이터 매니저 구현, 센서를 활용한 데이터 측정 구현|
|22.02.02|리스트 화면 페이지네이션 구현, 센서 데이터를 저장하고 관리하는 타입 구현|
|22.02.03|그래프 뷰 틀 구현, 측정 화면 세부 구현|
|22.02.04|그래프 뷰 구체화, 재생 화면 틀 구현|
|22.02.05|타입 변경에 따른 그래프 뷰 리팩토링 및 전체적인 리팩토링|

## 🎲 적용한 디자인 패턴이나 아키텍쳐
### Builder Pattern
Builder Pattern은 많은 생성자 인자를 넣어야 하는 경우에 사용하면 생성자 인자를 줄일 수 있다는 장점이 있는 패턴입니다. 저희는 AlertController를 구성하는 단계에서 다양한 인자를 생성자에 넣어야 하는 것이 불편하다고 생각하였습니다. 그래서 Director 타입이 없는 Builder Pattern을 활용하였습니다. 해당 파일은 Utilty 폴더 내에 존재하는 AlertBuilder 파일에서 확인하실 수 있습니다.

```swift!
protocol AlertBuilder {
    var alertController: UIAlertController { get }
    func setTitle(to title: String) -> AlertBuilder
    func setMessage(to message: String) -> AlertBuilder
    func setButton(
        title: String?,
        style: UIAlertAction.Style,
        completion: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder
    
    func build() -> UIAlertController
}

class AlertConcreteBuilder: AlertBuilder {
    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    func setTitle(to title: String) -> AlertBuilder {
        alertController.title = title
        return self
    }
    
    func setMessage(to message: String) -> AlertBuilder {
        alertController.message = message
        return self
    }
    
    func setButton(title: String?, style: UIAlertAction.Style, completion: ((UIAlertAction) -> Void)?) -> AlertBuilder {
        let action = UIAlertAction(title: title, style: style, handler: completion)
        alertController.addAction(action)
        return self
    }
    
    func build() -> UIAlertController {
        return alertController
    }
}


// Use of Client
let alert = AlertConcreteBuilder()
    .setTitle(to: error.alertTitle)
    .setMessage(to: error.alertMessage)
    .setButton(title: "확인", style: .default, completion: nil)
    .build()

present(alert, animated: true)
```


## 🚀 트러블 슈팅
### 비동기적 저장
데이터를 저장하기 위해서 비동기적으로 FileManager와 CoreData에 접근하려고 하였다. 하지만, 두가지의 함수가 비동기적으로 수행되기 때문에 시작되고, 끝나는 지점을 알 수 없으며, 이로 인해서 결과값을 판단하는 것이 어려웠다. 또한, 데이터를 저장한 것에 대한 결과를 받아오는 과정에서 이미 판단이 완료되었다고 생각하여서 Alert Controller가 생성되게 되는 문제가 있었다.

이를 해결하기 위해서 DispatchGroup 메서드를 활용하고, 이를 통해서 group 내의 모든 작업이 종료된 후에 결과값을 업데이트 할 수 있도록 하여서 업데이트에 대한 판단을 할 수 있도록 하였습니다.
