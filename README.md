# Gyro Data

6축 데이터(acc 3축 + gyro 3축)를 다뤄보는 앱입니다.
데이터를 생성하여 CoreData와 json파일로 저장하고, 불러오는 앱입니다.

## 목차

1. [팀 소개](#팀-소개)
2. [아키텍쳐 패턴](#아키텍쳐-패턴)
3. [폴더 구조](#-폴더-구조)

## 팀 소개

|[Gundy](https://github.com/Gundy93)|[Aaron](https://github.com/Hashswim)|
|:-:|:-:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://avatars.githubusercontent.com/u/106914201?v=4">|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://i.imgur.com/BL1PKGO.png">|
|GraphView, MeasurementMotionDataVM, VC 담당|CMMotionManager, replayMotionView, replayMotionViewModel 담당|

공동 작업 사항: Model, 첫 번째 화면의 VM 및 VC

## 아키텍쳐 패턴

데이터가 저장되는 앱 특성상, Model의 변화를 토대로 한 뷰모델과 뷰의 바인딩을 통해 구현하는 방법이 적절하다고 생각해 MVVM 패턴을 선택하게 되었습니다.

### MVVM 구조

![](https://i.imgur.com/1jZKpLi.png)

앱 분석에 따르면 화면은 총 세 개이며, 그에 따른 뷰 모델도 셋으로 구성하였습니다.

<details>
<summary> 
앱분석 펼쳐보기
</summary>

![](https://i.imgur.com/ZbDQkiY.png)
    
</details><br>

## 폴더 구조

```
GyroData
├── AppDelegate.swift
├── SceneDelegate.swift
├── Model
│   ├── MotionData
│   ├── MotionType
│   ├── ReplayType
│   ├── FileManager
│   ├── CoreData
│   │   ├── CoreDataManager
│   │   └── MotionDataModel
│   └── JSONData
│       └── JSONDataManager
├── View
│   ├── GraphView
│   ├── GraphViewDataSource
│   ├── GraphViewDataSource+
│   ├── MotionDataTable
│   │   ├── MotionDataTableViewController
│   │   └── MotionListCell
│   ├── MeasurementMotionData
│   │   └── MeasurementMotionDataViewController
│   └── ReplayMotion
│       └── ReplayMotionViewController
├── ViewModel
│   ├── MotionDataTable
│   │   └── MotionDataTableViewModel
│   ├── MeasurementMotionData
│   │   ├── MeasurementMotionDataViewModel
│   │   └── MotionDataManageable
│   └── ReplayMotion
│       ├── ReplayMotionViewModel
│       └── DateFormatter+
├── Resource
│   ├── Assets
│   └── Info.plist
└── Utility
    └── Reusable.swift
```

---

[⬆️ 맨 위로 이동하기](#Gyro-Data)
