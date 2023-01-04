# GyroData
> 프로젝트 기간: 2022-12-26 ~ 2022-12-30</br>
> 팀원: [백곰](https://github.com/Baek-Gom-95), [바드](https://github.com/bar-d)</br>

## 📑 목차
- [개발자 소개](#개발자-소개)
- [프로젝트 소개](#프로젝트-소개)
- [폴더 구조](#폴더-구조)
- [기능설명](#기능설명)
## 개발자 소개
|[바드](https://github.com/bar-d)|[백곰](https://github.com/Baek-Gom-95)|
|:---:|:---:|
| <img src = "https://i.imgur.com/wXKAg8F.jpg" width="250" height="250">| <img src = "https://i.imgur.com/5uwUyDt.jpg" width="250" height="250"> |

## 프로젝트 소개
- CMMotionManager를 통해 가속도와 회전 값을 받아와 기록하는 어플리케이션

## 폴더 구조
```
├── CoreDataFramework
│   ├── CoreDataFramework
│   │   ├── CoreDataFramework.docc
│   │   │   └── CoreDataFramework.md
│   │   ├── CoreDataFramework.h
│   │   └── CoreDataManager.swift
│   └── CoreDataFramework.xcodeproj
│       ├── project.pbxproj
│       ├── project.xcworkspace
│       │   ├── contents.xcworkspacedata
│       │   └── xcshareddata
│       │       └── IDEWorkspaceChecks.plist
│       └── xcuserdata
│           └── bard.xcuserdatad
│               └── xcschemes
│                   └── xcschememanagement.plist
├── GyroData
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Extension
│   │   ├── UIContextualAction+Extension.swift
│   │   └── UIImage+Extension.swift
│   ├── Manager
│   │   ├── MotionDataManager.swift
│   │   ├── MotionManager.swift
│   │   └── MotionType.swift
│   ├── Model
│   │   ├── CoordinateModel.swift
│   │   ├── GyroModel.swift
│   │   ├── MockModel.swift
│   │   └── ReuseIdentifying.swift
│   ├── Protocol
│   │   └── ReuseIdentifiable.swift
│   ├── Resource
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   ├── Contents.json
│   │   │   ├── DeleteColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── PlayColor.colorset
│   │   │   │   └── Contents.json
│   │   │   └── SelectedColor.colorset
│   │   │       └── Contents.json
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   ├── Info.plist
│   │   └── Model.xcdatamodeld
│   │       └── Model.xcdatamodel
│   │           └── contents
│   └── Scene
│       ├── Common
│       │   ├── GraphType.swift
│       │   ├── GraphView.swift
│       │   └── GridView.swift
│       ├── Main
│       │   ├── MainTableViewCell.swift
│       │   └── MainViewController.swift
│       ├── MeasurementEnrollment
│       │   ├── CustomSegmentedControl.swift
│       │   └── MeasurementEnrollController.swift
│       └── MeasurementReplay
│           ├── MeasurementReplayViewController.swift
│           └── PlayType.swift
├── GyroData.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   └── swiftpm
│   │   │       └── configuration
│   │   └── xcuserdata
│   │       ├── bard.xcuserdatad
│   │       │   └── UserInterfaceState.xcuserstate
│   │       └── kjs.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   └── xcuserdata
│       ├── bard.xcuserdatad
│       │   ├── xcdebugger
│       │   │   └── Breakpoints_v2.xcbkptlist
│       │   └── xcschemes
│       │       └── xcschememanagement.plist
│       └── kjs.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── MotionEntity+CoreDataClass.swift
└── MotionEntity+CoreDataProperties.swift
```
## 기능설명

### CoreDataFramework
- 기존에 만들어 놓은 CoreDataFrameWork를 통한 CoreData 구현

### MotionManager
- CMMotionManager를 통한 가속도, 회전 값을 받아오는 매니저

### MotionDataManager
- MotionManager를 통해 받아온 값을 코어 데이터에 저장하는 매니저



