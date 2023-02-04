# GyroData

> **개발기간: 2023.1.29 ~ 2023.2.4**

<br/>

## ⭐️ 프로젝트 소개

자이로스코프 센서와 가속도 센서를 관측하고 저장해 두어 언제든 다시 볼 수 있는 앱입니다.

<br/>

## 🍎 팀 소개

| [제이푸시](https://github.com/jjpush) | [Kyo](https://github.com/KyoPak) |
|:-:|:-:|
|<img src="https://i.imgur.com/MKssfcb.jpg" width=200>|<img width="180px" img src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|

<br/>

## ⚙️ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]() [![xcode](https://img.shields.io/badge/Xcode-14.2-blue)]()

only apple FrameWork

<br/>

## 폴더
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

## 🌟 프로젝트 주요 기능

### Sensor 관측 및 scale 조정

|Accelerometer|Gyroscope|
|:-----:|:-----:|
|<img src="https://i.imgur.com/5SibbrZ.gif" width=300>|<img src="https://i.imgur.com/0P5T57h.gif" width=300>|

### List

|라이트 모드|다크 모드|페이지네이션|
|:-----:|:----:|:-----:|
|<img src="https://i.imgur.com/zX33lKR.png" width=300>|<img src="https://i.imgur.com/6xxfVsR.png" width=300>|<img src="https://user-images.githubusercontent.com/59204352/216769608-51938654-6014-4eb6-8b81-e11c86f0e08c.gif" width=300>|

### Graph Detail

|Play Accelerometer|Play Gyroscope|View|
|:-----:|:-----:|:----:|
|<img src="https://i.imgur.com/Q7NjxiA.gif" width=300>|<img src="https://i.imgur.com/wWE1FT2.gif" width=300>|<img src="https://i.imgur.com/6ph3BH2.png" width=300>|

<br/>
