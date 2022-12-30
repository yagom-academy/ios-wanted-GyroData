# 🧭 GyroData

## 🪧 목차
- [📜 프로젝트 및 개발자 소개](#-프로젝트-및-개발자-소개)
- [🙌 팀원 역할](#-팀원-역할)
- [💡 키워드](#-키워드)
- [📱 구현 화면](#-구현-화면)
- [🏛 프로젝트 구조](#-프로젝트-구조)
- [👩🏻‍💻 코드 설명](#-코드-설명)
- [📁 폴더 구조](#-폴더-구조)
<br>

## 📜 프로젝트 및 개발자 소개
> **소개** : Accelerometer와 Gyroscope를 측정해주는 앱 <br>**프로젝트 기간** : 2022.12.26 ~ 2022.12.30

| **Judy** | **제리** |
|:---:|:---:|
<img src="https://i.imgur.com/n304TQO.jpg" width="300" height="300" />|<img src="https://i.imgur.com/DnKXXzd.jpg" width="300" height="300" />|
|[@Judy-999](https://github.com/Judy-999)|[Jerry_hoyoung](https://github.com/llghdud921)|
<br>

## 🙌 팀원 역할

### 주디 🐰
- MotionMeasurement 화면
- GraphicView 
- FileManager

### 제리 🐭
- MotionListScene 화면 
- MotionResultScene 화면 
- CoreData 
<br>

## 💡 키워드
- **CoreMotion**
- **CoreGraphics**
- **CoreData**
- **FileManager**
- **Observable**

<br>

## 📱 구현 화면

|**측정 및 저장** | **스와이프로 데이터 삭제** | 
| :--------: | :--------: |
|  <img src = "https://user-images.githubusercontent.com/102353787/210079020-bda21a18-311c-45b3-9c53-1562e657ab8a.gif" width="300" height="600">|  <img src = "https://user-images.githubusercontent.com/102353787/210079175-d165f0bc-bbef-46f3-a542-1ee955774c15.gif" width="300" height="600"> | 

| **저장된 데이터 보기**|
|:--------: |
|<img src = "https://user-images.githubusercontent.com/102353787/210079204-d1e82794-4416-480a-9f68-beec1eb55fa4.gif" width="300" height="600">|

<br>

## 🏛 프로젝트 구조

### MVVM 

**ViewModel** 
view에서 받은 이벤트를 가지고 데이터를 가공하여 CoreData, fileManager에 전달

**View**
사용자의 입력을 받아 ViewModel에 이벤트를 전달하고 ViewModel로부터 데이터를 가져와 화면에 출력

**Model** 
 데이터 구조를 정의
 
### Obsevable을 이용한 데이터 바인딩

MVVM 구조에서 `ViewModel`과 `View`의 데이터를 바인딩하기 위해 `Observable` 클래스를 구현하여 사용

<br>

## 👩🏻‍💻 코드 설명

### FileDataManager 
- `FileManager`를 통해 데이터를 다루는 클래스로 `fetch`, `save`, `delete` 메서드로 구성 
- `Codable`을 채택한 타입으로만 사용 가능
- Document에 **CoreMotion** 폴더를 생성하여 파일을 관리

### CoreDataManager 
- `CoreData`에 접근하는 클래스로 `fetch`, `save`, `delete` 메서드로 구성 
- `CoreData`의 `NSManagedObject` 모델 타입이 `Storable protocol`을 채택하여 해당 모델 타입만 `CoreDataManager`에 접근할 수 있도록 로직을 구현

### GraphView 
- 한 틱의 데이터를 `GraphSegment`로 생성해 그래프를 그리는 View
- `CoreGrahpics`로 그래프의 격자무늬와 한 틱의 그래프 표현

### MotionMeasurementManager 
- **Accelerometer**와 **Gyroscope**를 측정하는 클래스
- `CoreMotion`의 `CMMotionManager`와 `Timer`를 이용해 측정

### UseCase
- `CoreData`, `FileManager` 등 데이터를 주고받기 위한 행위를 정의
- 모델 간 mapping하거나 Motion data를 모델링하는 로직이 포함
- `FileManager`, `CoreDataManager`와의 의존성을 줄이기 위함

<br>

## 📁 폴더 구조

```
├── Domain
│   ├── Entities
│   │   ├── Motion.swift
│   │   ├── MotionInformation.swift
│   │   ├── MotionResultType.swift
│   │   └── MotionType.swift
│   └── UseCase
│       ├── MotionCoreDataUseCase.swift
│       └── MotionFileManagerUseCase.swift
├── Scenes
│   ├── MotionListScene
│   │   ├── MotionListViewController.swift
│   │   └── MotionListViewModel.swift
│   │       
│   ├── MotionMeasurementScene
│   │   ├── MeasurementViewController.swift
│   │   └── MotionMeasurementViewModel.swift
│   │       
│   └── MotionResultScene
│       ├── MotionResultPlayViewController.swift
│       ├── MotionResultViewController.swift
│       └── MotionResultViewModel.swift           
├── Service
│   ├── CoreData
│   │   ├── CoreDataError.swift
│   │   ├── CoreDataManager.swift
│   │   ├── CoreDataStack.swift
│   │   └── Entities
│   │       ├── MotionInfo+CoreDataClass.swift
│   │       ├── MotionInfo+CoreDataProperties.swift
│   │       ├── MotionInfo.xcdatamodeld
│   │       └── Storable.swift
│   └── FileManager
│       ├── FileDataManager.swift
│       └── FileManagerError.swift
└── Utility
    ├── GraphView
    │   ├── Entities
    │   │   ├── GraphNumber.swift
    │   │   └── MotionData.swift
    │   └── GraphView.swift
    │         
    ├── MeasurementManager
    │   ├── MotionMeasurementManager.swift
    │   └── Protocol
    │       └── Measurementable.swift
    └── Observable
        └── Observable.swift
```

<br><br> 
