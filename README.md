# 📈 GyroData App
**사용자의 기기에서 가속도, 자이로 값을 측정하는 애플리케이션입니다.**

> 프로젝트 기간: 23.1.30 ~ 23.2.5 (7일)
> 팀원: 인호, 애종, 하모

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [적용 기술](#-적용-기술)
4. [폴더 구조](#-폴더-구조)

## 🧑‍💻 팀 소개
|[인호](https://github.com/inho-98)|[애종](https://github.com/jonghancha)|[하모](https://github.com/lxodud)|
|:-:|:-:|:-:|
|<a href="https://github.com/inho-98"><img width="180px" src="https://user-images.githubusercontent.com/71054048/188081997-a9ac5789-ddd6-4682-abb1-90d2722cf998.jpg"></a>|<a href="https://github.com/inho-98"><img width="180px" src="https://i.imgur.com/7K7rXiB.jpg"></a>|<a href="https://github.com/inho-98"><img width="180px" src="https://i.imgur.com/PcNDqvt.png"></a>|
|`CoreData`, `ListScene`|`FileManager`, `MeasureScene, GraphView`|`CoreMotion`, `DetailScene, GraphView`|

## 📱 기능 소개
#### 1.메인 리스트![]()

|<img src=https://i.imgur.com/aZF0ooW.gif width=200>|<img src=https://i.imgur.com/hjt0Eas.gif  width=200>|
|:-:|:-:|
|페이징|삭제|
#### 2.가속도, 자이로 측정화면

|<img src=https://i.imgur.com/VK5R6sC.gif  width=200>|<img src=https://i.imgur.com/9O69BAP.gif  width=200>|
|:-:|:-:|
|가속도 측정|자이로 측정|
#### 3.측정내용 View, Play화면

|<img src=https://i.imgur.com/IOTl3cd.gif  width=200>|
|:-:|
|그래프 Play|

## ⚙ 적용 기술
#### `MVVM`
- `ViewController`의 코드가 방대해지는 것을 방지하고, 뷰에 보여질 데이터 및 비즈니스 로직의 분리를 명확히 하기 위해 `MVVM`을 적용하였습니다.
- 데이터 및 비즈니스 로직은 `ViewModel`, 뷰의 상태 관리는 `ViewController`, 뷰를 생성하는 로직은 `View`로 분리하였습니다.

#### `CoreData` & `FileManager`
- `CoreData`에는 모델의 생성 일자, 측정 기간, 측정 타입`(Gyo, Acc), UUID`값을 저장합니다.
- `FileManager`에는 측정한 결과값 배열을 저장하고, 모델의 UUID값을 통해 접근합니다.

#### `CoreMotion`
- 사용자 기기의 `Gyro & Acc`값을 측정합니다.
- `Gyro & Acc` 측정 기능의 공통되는 부분을 프로토콜에 구현하였습니다.

#### `GraphView`
- `UIBezierPath`를 이용하여 그래프를 그려줍니다.
- 뷰에 격자를 보여주는 부분과 그래프를 보여주는 부분을 분리하여 구현하였습니다.

## 📂 폴더 구조
```
├── Info.plist
├── MotionDataModel.xcdatamodeld
│   └── MotionDataModel.xcdatamodel
│       └── contents
├── Resource
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   └── Base.lproj
│       └── LaunchScreen.storyboard
└── Source
    ├── App
    │   ├── AppDelegate.swift
    │   └── SceneDelegate.swift
    ├── Error
    │   ├── CoreDataError.swift
    │   ├── FileManagingError.swift
    │   └── MotionManagerError.swift
    ├── GraphView
    │   ├── GraphBackgroundView.swift
    │   ├── GraphView.swift
    │   └── GraphViewModel.swift
    ├── Model
    │   ├── MotionCoordinate.swift
    │   ├── MotionData.swift
    │   ├── MotionMeasures.swift
    │   └── MotionType.swift
    ├── Protocol
    │   ├── CoreDataManageable.swift
    │   ├── FileManagerProtocol.swift
    │   └── MotionManagerable.swift
    ├── Scene
    │   ├── DetailScene
    │   │   ├── DetailView.swift
    │   │   ├── DetailViewController.swift
    │   │   └── DetailViewModel.swift
    │   ├── ListScene
    │   │   ├── DateFormatter +.swift
    │   │   ├── MainViewController.swift
    │   │   ├── MainViewModel.swift
    │   │   ├── MotionCellViewModel.swift
    │   │   └── MotionDataCell.swift
    │   └── MeasureScene
    │       ├── MeasureViewController.swift
    │       └── MeasureViewModel.swift
    └── Service
        ├── AccelerometerMotionManager.swift
        ├── FileHandleManager.swift
        ├── GyroMotionManager.swift
        └── MeasureTimer.swift
```
