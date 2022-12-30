# Gyro Data

## 🙋🏻‍♂️ 프로젝트 소개
원티드 프리온 보딩 `GyroData` 앱 프로젝트 입니다.

> 프로젝트 기간: 2022-12-26 ~ 2022-12-30 (5일)
> 팀원: [브래드](https://github.com/bradheo65), [웡빙](https://github.com/wongbingg), [민쏜](https://github.com/minsson)

## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [🔑 핵심기술](#-핵심기술)
- [📱 실행화면](#-실행화면)
- [⚙️ 적용한 기술](#-적용한-기술)
- [🛠 아쉬운 점](#-아쉬운-점)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|[브래드](https://github.com/bradheo65)|[웡빙](https://github.com/wongbingg)|[민쏜]()|
|:---:|:---:|:---:|
|<image src = "https://i.imgur.com/35bM0jV.png" width="250" height="250">|<image src = "https://i.imgur.com/fQDo8rV.jpg" width="250" height="250">|<image src = "https://avatars.githubusercontent.com/u/96630194?v=4?s=100" width="250" height="250">|
|`CoreMotion`|`CoreData`, `FileManager`|`Graph View`|  


## 🔑 핵심기술
- **`MVVM 패턴`**
    - 데이터 관련 로직은 ViewModel, 뷰의 상태 관리는 ViewContoller, 뷰의 로직은 View로 MVVM 패턴을 사용해 이번 프로젝트를 진행해 보았습니다.
- **`디자인패턴`**
    - 옵저버블패턴
        - MVVM 구현시 데이터 바인딩을 위해 옵저버블 패턴으로 구현을 해보았습니다.
- **`UI 구현`**
    - 코드 베이스 UI
    - 오토레이아웃
- **`파일 저장 형식`**
    - CoreData
    - JSON(FileManger)
- **`비동기처리`**
    - @escaping closer

## 📱 실행화면
    
|||
|:---:|:---:|
|<image src = "https://i.imgur.com/cOSb1tw.gif">|<image src = "https://i.imgur.com/vxbzFKf.gif">|
|`측정, 저장 화면`|`삭제 화면`|

|||
|:---:|:---:|
|<image src = "https://i.imgur.com/DYcJZwn.gif">|<image src = "https://i.imgur.com/4XmRmK5.gif">|
|`다시보기 화면`|`Play 화면`|

    
## 🔭 프로젝트 구조

### - File Tree
    
```
├── AppDelegate.swift
├── Assets.xcassets
│   ├── AccentColor.colorset
│   │   └── Contents.json
│   ├── AppIcon.appiconset
│   │   └── Contents.json
│   └── Contents.json
├── Base.lproj
│   └── LaunchScreen.storyboard
├── Common
│   └── Sensor.swift
├── Extension
│   ├── Date+Extension.swift
│   └── Double+Extension.swift
├── GraphView
│   ├── GraphBackgroundView.swift
│   ├── GraphContainerView.swift
│   ├── GraphView.swift
│   └── UIBezierPath+Extension.swift
├── Info.plist
├── Manager
│   ├── AlertBuilder.swift
│   ├── CoreDataManager.swift
│   ├── CoreMotionManager.swift
│   └── FileHandleManager.swift
├── Model
│   ├── CellData.swift
│   ├── MeasuredData.swift
│   └── Observable.swift
├── MotionData.xcdatamodeld
│   └── MotionData.xcdatamodel
│       └── contents
├── SceneDelegate.swift
├── View
│   ├── DetailView
│   │   ├── DetailView.swift
│   │   └── DetailViewController.swift
│   ├── ListView
│   │   ├── ListView.swift
│   │   ├── ListViewCell.swift
│   │   └── ListViewController.swift
│   └── MeasureView
│       ├── MeasureView.swift
│       └── MeasureViewController.swift
├── ViewController
└── ViewModel
    ├── DetailViewModel.swift
    ├── ListViewModel.swift
    └── MeasureViewModel.swift
```
    
추가 예정
    

## ⚙️ 적용한 기술

### ✅ Core Data 

- 코어데이터를 이용하여 셀 데이터 저장
- 코어모션매니저에서 측정한 결과값 배열을 FileManager를 통해 JSON 형식 파일로 저장
    
    
    
### ✅ Core Motion

- 기기의 Gyro, Acc를 측정하기위한 CoreMotionManager를 구현
- start(시작), stop(종료), deliver(데이터 전달) 기능 별로 메소드를 만들어 관리
    
### ✅ Graph View

- UIBezierPath를 활용하여 GraphView를 구현
    - Swift Charts 프레임워크의 사용을 고려했으나, iOS 16 이상 버전부터 사용 가능하므로 현 시점의 버전을 고려하여 UIBezierPath 활용
- Graph View의 구성
    - GraphContainerView: 아래의 두 뷰를 담는 컨테이너 뷰
    - GraphBackgroundView: 그래프의 배경이 되는 그리드를 그리는 뷰
    - GraphView: 그래프와 x, y, z 레이블을 표시

## 🛠 아쉬운 점
    
- 그래프가 자동적으로 높이 조절을 하는 기능을 넣지 못했다.

