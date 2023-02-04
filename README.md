# 📊 GyroData

 </br>
 
## 🗣 프로젝트 및 개발자 소개
>소개: 6축 자이로 / 가속도 센서를 측정하여 화면에 그래프를 그려주는 </br>
>`iPhone` 전용 **GyroData** 앱입니다. </br>
>프로젝트 기간 : **2023-01-30 ~ 2023-02-05**

|[@zhilly](https://github.com/zhilly11)|[@woong](https://github.com/iOS-Woong)|
|:---:|:---:|
|<img src = "https://i.imgur.com/LI4k2B7.jpg" width=300 height=300>|<img src = "https://i.imgur.com/iF9OiA4.jpg" width=300 height=300>|
 </br>
 
 

## 📱 실행화면

| 목록 화면 | 스와이프 액션 | 측정화면 화면 |
| :--------: | :--------: | :--------: |
| <img src = "https://i.imgur.com/LZ3GxVN.png" width=300 height=600> | <img src = "https://i.imgur.com/GInINdj.png" width=300 height=600>    | <img src = "https://i.imgur.com/m7B59c8.png" width=300 height=600>     |

| 측정중에는 정지만 가능 | 측정 데이터 조회 (View) | 측정 데이터 조회 (Play) |
| :--------: | :--------: | :--------: |
| <img src = "https://i.imgur.com/iUEqYE2.png" width=300 height=600>     | <img src = "https://i.imgur.com/QZUbNkE.png" width=300 height=600> | <img src = "https://i.imgur.com/6Ankr4M.png" width=300 height=600> |



| 그래프 재생 |
| :--------: |
| <img src = "https://i.imgur.com/3osk1gW.gif" width=300 height=600>|

 </br>
 
## 🛠️ 적용기술

- `MVVM`
    - ViewController가 비대해지는 문제를 막고, 구현 간 코드수정 및 추후 유지보수에 용이하게 하기 위해 MVVM 패턴을 선택하였습니다.
    - Observable 객체를 통한 데이터 바인딩을 구현했습니다.
- `CoreData`
    - CRUD 기능을 담당하는 `CoreDataManager`를 구현하였습니다.
- `CoreMotion`
    - Accelerometer와 Gyroscope를 측정하는 `CoreMotionManager`를 구현하였습니다.
- `FileManager`
    - `json` 형식으로 데이터를 저장하고 불러올 수 있는 `FileManager` 추가기능을 구현하였습니다.
- `Graph`
    - `UIBasierPath`와 `CAShapeLayer`를 활용하여 그래프를 그리는 기능을 구현하였습니다.

 </br>
 
## 🗂️ 폴더 구조
```bash
GyroData
├── Source
│   ├── App
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Extension
│   │   ├── Array+Extension.swift
│   │   ├── DateFormatter+Extension.swift
│   │   ├── FileManager+Extension.swift
│   │   └── NotificationName+Extension.swift
│   ├── Manager
│   │   ├── CoreDataManager
│   │   │   ├── CoreDataManageable.swift
│   │   │   ├── CoreDataManager.swift
│   │   │   └── ManagedObjectModel.swift
│   │   └── CoreMotionManager.swift
│   ├── Model
│   │   ├── MotionCoreModel+CoreDataClass.swift
│   │   ├── MotionCoreModel+CoreDataProperties.swift
│   │   ├── FileManagedData.swift
│   │   ├── MotionData.swift
│   │   ├── Observable.swift
│   │   └── SensorData.swift
│   ├── Protocol
│   │   └── ReusableView.swift
│   └── View
│       ├── CustomView
│       │   └── GraphView.swift
│       ├── DetailView
│       │   ├── DetailViewController.swift
│       │   └── DetailViewModel.swift
│       ├── ListView
│       │   ├── MeasureListViewController.swift
│       │   ├── MeasureListViewModel.swift
│       │   └── MeasureTableViewCell.swift
│       └── MeasureView
│           ├── MeasureViewController.swift
│           └── MeasureViewModel.swift
├── Resource
│   ├── Enum
│   │   ├── CoreDataManagerError.swift
│   │   ├── DetailViewMode.swift
│   │   └── SensorMode.swift
│   │── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   └── Base.lproj
│       └── LaunchScreen.storyboard
│
├── Info.plist
└── Motion.xcdatamodeld
```
