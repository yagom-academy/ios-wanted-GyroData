# GyroData

> **개발기간: 2023.1.29 ~ 2023.2.4**

<br/>

## 1️⃣ 프로젝트 소개

자이로스코프 센서와 가속도 센서를 관측하고 저장해 두어 언제든 다시 볼 수 있는 앱입니다.

<br/>

## 2️⃣ 팀 소개

| [제이푸시](https://github.com/jjpush) | [Kyo](https://github.com/KyoPak) |
|:-:|:-:|
|<img src="https://i.imgur.com/MKssfcb.jpg" width=200>|<img width="180px" img src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|

<br/>

## 3️⃣ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]() [![xcode](https://img.shields.io/badge/Xcode-14.2-blue)]()

only apple FrameWork

<br/>

## 4️⃣ 폴더

<details>
<summary> 
펼쳐보기
</summary>

```
├── GyroData
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   └── Info.plist
│   └── Source
│       ├── Application
│       │   ├── AppDelegate.swift
│       │   └── SceneDelegate.swift
│       ├── Common
│       │   ├── Builder
│       │   │   ├── AlertBuilder.swift
│       │   │   └── ErrorAlertBuilder.swift
│       │   ├── Director
│       │   │   └── AlertDirector.swift
│       │   ├── Error
│       │   │   ├── CoreDataError.swift
│       │   │   └── FileSystemError.swift
│       │   └── Extension
│       │       ├── DateFormatter+Extension.swift
│       │       └── UIComponent+Extension.swift
│       ├── Data
│       │   ├── CoreData
│       │   │   └── SensorData.xcdatamodeld
│       │   ├── CoreDataManager.swift
│       │   └── FileSystemManager.swift
│       ├── Domain
│       │   ├── Entities
│       │   │   ├── MeasureData.swift
│       │   │   └── Sensor.swift
│       │   ├── Protocol
│       │   │   ├── DataManageable.swift
│       │   │   ├── FileManageable.swift
│       │   │   ├── Identifiable.swift
│       │   │   └── MeasureServiceDelegate.swift
│       │   ├── SensorMeasureService.swift
│       │   └── TransactionService.swift
│       └── Presentation
│           ├── Common
│           │   └── Views
│           │       └── GraphView.swift
│           ├── DataListScene
│           │   ├── DataListViewController.swift
│           │   ├── DataListViewModel.swift
│           │   └── MeasureDataCell.swift
│           ├── MeasureScene
│           │   ├── MeasureViewController.swift
│           │   └── MeasureViewModel.swift
│           ├── ReviewScene
│           |    ├── DetailViewController.swift
│           |    └── DetailViewModel.swift
│           ├── PlayScene
│           │   ├── PlayViewController.swift
│           │   └── PlayViewModel.swift
│           └── Protocol
│               ├── GraphViewPlayDelegate.swift
│               ├── MeasureViewDelegate.swift
│               └── PlayViewDelegate.swift
├── GyroDataTests
│   ├── Common
│   │   ├── Dummy
│   │   │   └── MeasureDataDummy.swift
│   │   └── Stub
│   │       ├── CoreDataManagerStub.swift
│   │       └── FileSystemManagerStub.swift
│   └── TransactionServiceTests
│       └── TransactionServiceTests.swift
├── SensorData+CoreDataClass.swift
└── SensorData+CoreDataProperties.swift
```
</details>
    
## 5️⃣ 프로젝트 주요 기능

### Sensor 관측 및 scale 조정

|Accelerometer|Gyroscope|
|:-----:|:-----:|
|<img src="https://i.imgur.com/5SibbrZ.gif" width=250>|<img src="https://i.imgur.com/0P5T57h.gif" width=250>|

### List

|라이트 모드|다크 모드|페이지네이션|
|:-----:|:----:|:-----:|
|<img src="https://i.imgur.com/zX33lKR.png" width=250>|<img src="https://i.imgur.com/6xxfVsR.png" width=250>|<img src="https://user-images.githubusercontent.com/59204352/216769608-51938654-6014-4eb6-8b81-e11c86f0e08c.gif" width=250>|

### Graph Detail

|Play Accelerometer|Play Gyroscope|View|
|:-----:|:-----:|:----:|
|<img src="https://i.imgur.com/Q7NjxiA.gif" width=250>|<img src="https://i.imgur.com/wWE1FT2.gif" width=250>|<img src="https://i.imgur.com/6ph3BH2.png" width=250>|

<br/>


## 6️⃣ 아키텍쳐 및 디자인 패턴

### MVVM & Clean Architecture

> Clean Architecture
- 관심사를 분리하고 계층의 역할을 명확하게 하기위해서 `Clean Architecture`를 적용해 보았습니다. 각 계층을 `layer architecture`를 참고하여 `Presentaion`, `Domain`, `Data` 3개의 layer로 나누었고, `usecase`의 역할을 `service`가, `repository`의 역할을 `Manager`가 담당하도록 했습니다.
- CoreData가 realm으로 바뀌는 등의 **상황에 대처**할 수 있도록 `repository`의 역할을 추상화 했습니다.
- Presentation 영역에서 각 화면을 Scene별로 분리하여 쉽게 찾을 수 있도록 파일을 분리해주었습니다.

> MVVM 
- MVVM 패턴을 사용해서 `ViewModel`에서 `UIKit`을 가지지 않게 설계해서 단위 테스트를 가능하도록 했습니다.
- `ViewController`는 **View를 그리는 역할**만, `ViewModel`은 뷰에서 **필요한 로직을 담당**하도록 분리했습니다.

> Input/Output Modeling
- `Clean Architecture`를 지키기 위해`ViewController`와 `ViewModel` 간에 **Input/Output 인터페이스**를 통해서 값을 주고 받을 수 있도록 설계 했습니다.
- 뷰에서 들어오는 **Event**를 `Input`, 뷰에서 필요한 **데이터**를 `Output`으로 보내주었습니다.
- 이번 프로젝트에서는 **Enum**으로 `Input`인 **Action**을 가지고 **Delegate**를 통해 `Output`으로 내보내주었습니다.
- 일부 타입 중 `Output`이 하나밖에 없는 경우 **오버엔지니어링**이라고 판단해 **handler**를 통해 `Output`을 보내주었습니다.

## 디자인 패턴

### Builder
- alert 객체를 생성하며 생성 시 각 상황에 맞는 데이터를 쉽게 입력받아 사용할 수 있도록 Builder를 만들어 주었습니다.

</br>

## 7️⃣ 설명

### Presentation Layer

>DataListScene

- 측정된 데이터들을 테이블 뷰 형태로 보여주는 화면 입니다.
- 한번에 10개의 데이터를 가져오고 아래로 스크롤 시 10개씩 데이터를 추가합니다.

>MeasureScene

- Sensor의 값을 측정하고 보여주어 저장할 수 있는 화면입니다.
- Accelerometer와 gyro 센서 중 선택하여 저장할 수 있습니다.
- 저장 시 indicator를 추가해서 사용자가 저장 중인지 알 수 있도록 합니다.

>ReviewScene

- 테이블 뷰의 각 데이터를 자세히 볼 수 있는 화면입니다.
- 그래프의 형태로 자세히 볼 수 있습니다.

>PlayScene

- Cell을 Swipe하여 Play를 클릭 후 볼 수 있는 화면이며, 해당화면에서 시간의 흐름에 따라 
  Accelerometer, Gyro의 값들이 그래프를 그리는 것을 볼 수 있습니다.

### Domain Layer

>TransactionService

- 데이터베이스의 단위인 트랜잭션을 담당하는 객체입니다.
- ViewModel들이 해당Sevice를 통해 CoreData, FileManager의 Document에 저장할 수 있도록 하였습니다.
- usecase 역할을 하는 service 객체 입니다

>SensorMeasureService

- CoreMotion을 import 하고 센서들의 값을 받아오는 역할을 담당하는 객체입니다.
- 해당 서비스를 통해 MeasureScene 에서 값을 받을 수 있게 됩니다.
- usecase 역할을 하는 service 객체 입니다

### Data Layer
>CoreDataManager

- CoreData에 save, fetch, delete할 수 있는 관리 Class입니다.
- `clean architecture`의 repository 역할을 하고 있습니다.

>FileSystemManager

- FileManager에 save, fetch, delete할 수 있는 관리 Class입니다.
- 마찬가지로 `clean architecture`의 repository 역할을 하고 있습니다.

<br/>

## 8️⃣ 기여한 부분

Kyo
- Presentation
    - DataListScene
    - ReviewScene
- Common
    - Alert Builder
- Service
    - TransactionService
- Domain
    - FileSystemManager

제이푸시
- Presentation
    - MeasureScene
    - PlayScene
    - Views - GraphView
- Service
    - SensorMeasureService
- Domain
    - CoreDataManager


<br/>
