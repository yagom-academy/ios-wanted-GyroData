# ios-wanted-GyroData

## 프로젝트 기간
> 2023-01-30 ~ 2023-02-05 

## 프로젝트 소개
`Accelerometer`, `Gyro` 센서를 이용해 그래프를 작성하는 App입니다.

## 팀원 

| [LJ](https://github.com/lj-7-77) |   [Stone](https://github.com/lws2269)    |
| ----------- | ---------- |
|<img src="https://i.imgur.com/ggU7PLR.jpg" width="300px">|<img src="https://i.imgur.com/BME9vXX.png/" width="300px">|
 
## 폴더 구조
```
.
└── GyroData/
    ├── Resource/
    │   ├── Assets.xcassets
    │   ├── LaunchScreen.storyboard
    │   ├── MotionData.xcdatamodeld
    │   └── Info.plist
    ├── Utils/
    │   ├── Extension/
    │   │   ├── Date+Extension.swift
    │   │   └── Double+Extension.swift
    │   ├── CoreDataManager.swift
    │   ├── FileManager.swift
    │   └── MotionManager.swift
    ├── Model/
    │   ├── CoreData/
    │   │   ├── MotionEntity+CoreDataClass.swift
    │   │   └── MotionEntity+CoreDataProperties.swift
    │   ├── MotionType.swift
    │   ├── MeasureData.swift
    │   ├── Coordinate.swift
    │   └── MeasureViewType.swift
    ├── View/
    │   ├── ListCell.swift
    │   ├── MeasureViewController.swift
    │   ├── MeasureDetiailViewController.swift
    │   ├── MainListViewController.swift
    │   └── GraphView.swift
    ├── ViewModel/
    │   ├── ListCellViewModel.swift
    │   ├── MainListViewModel.swift
    │   ├── MeasureViewModel.swift
    │   └── MeasureDetailViewModel.swift
    └── LifeCycle/
        ├── AppDelegate.swift
        └── SceneDelegate.swift
```

## 구현 화면
| 테이블뷰, 스크롤 | 측정  | Swipe(Play), IndicatorView |
| -------- | -------- | -------- |
| <img src="https://i.imgur.com/503Jq77.gif" width=300> | <img src="https://i.imgur.com/s7FbipR.gif" width=300> | <img src="https://i.imgur.com/Cq0nmDx.gif" width=300> |

| 스케일처리 | Swipe(Delete) | Alert |
| -------- | -------- | -------- |
| <img src="https://i.imgur.com/Xy330Bw.gif" width=300> | <img src="https://i.imgur.com/UYTdGWI.gif" width=300> | <img src="https://i.imgur.com/vSO9AxO.gif" width=300> |


## 구현 내용
- MVVM 아키텍처를 적용하여 구현하였습니다. 아래는 코드에 대한 간략한 설명입니다.

### Utils
- `CoreDataManager`
    - `CoreData`의 `Create`, `Read`, `Delete`를 담당하는 객체입니다. 제네릭을 통해 구현하였고, 싱글톤 패턴을 적용하였습니다.
- `FileManager`
    - 그래프 뷰의 측정 값을 파일로 생성하는 객체입니다. 
- `MotionManager`
    - `CMMotionManager`를 가지고 있는 객체로 반복속도에 대한 값과, 경과 값을 담고있는 객체입니다. 상태에 따라 `Gyro`, `Accelormeter` 두가지 센서를 핸들링 합니다.
- `Extension`
    - `Date+Extension`
        - 인자로 받는 formmat형식으로 `Date`의 formmat을 변경하여 String으로 반환할 수 있도록 `Date`타입을 확장 구현하였습니다.
    - `Double+Extension` 
        - 소수점 자리수에 맞게 반올림하여 반환하는 메서드를 확장 구현하였습니다.
### Model
- `MotionType`
    - 센서에 대한 타입 `acc`, `gyro`를 가지고 있는 `enum`입니다
- `MeasureData`
    - `CMAccelerometerData`, `CMGyroData` 두가지의 타입을 하나의 타입으로 사용하기 위해 구현한 `MeasureData` 프로토콜 입니다.
- `Coordinate`
    - 센서로 측정한 x,y,z 에 대한 데이터 모델입니다.
- `MeasureViewType`
    - 결과 값을 보여주는 View, Play페이지에서 페이지에 대한 타입을 가지고 있는 `enum`입니다.

### View
- `ListCell`
    - `MeasureViewController` - `UITableView`에 사용되는 `CustomCell`입니다.
- `MeasureViewController`
    - `Accelerometer`, `Gyro` 두가지 센서 중 선택하여 값을 측정하는 `View`입니다. 측정 값은 실시간으로 `GraphView`를 통해 표출합니다.
- `MeasureDetiailViewController`
    - `MeasureViewController`을 통해 측정한 값을 볼 수 있는 `View`입니다. `View`, `Play` 두가지 타입을 통해 한번에 보여질지, 실시간으로 보여질지 선택합니다.
- `MainListViewController`
    - 측정 값에 대한 간소화한 값 - `Type`, `Time`, `Date`을 TableView 형태로 보여지는 `View`입니다.
- `GraphView`
    - 그래프에 대한 값을 가지고, 보여주는 `View`입니다.

### ViewModel
- `ListCellViewModel`
    - ListCell에 대한 데이터와 동작을 가지고 있는 `ViewModel`입니다.
- `MainListViewModel`
    - MainListViewModel 대한 데이터와 동작을 가지고 있는 `ViewModel`입니다.
- `MeasureViewModel`
    - MeasureViewModel 대한 데이터와 동작을 가지고 있는 `ViewModel`입니다.
- `MeasureDetailViewModel`
    - MeasureDetailViewModel 대한 데이터와 동작을 가지고 있는 `ViewModel`입니다.
   
---
