# 📐 Gyro Data

## 📖 목차
1. [앱 소개](#-앱-소개)
2. [팀 소개](#-팀-소개)
3. [실행 화면](#-실행-화면)
4. [Diagram](#-diagram)
5. [사용한 기술](#-사용한-기술)
6. [폴더 구조](#-폴더-구조)
7. [타임라인](#-타임라인)


## 🔬 앱 소개
- Ayaan과 Wonbi가 만든 GyroData App입니다.
- GyroData App은 6축 데이터(acc 3축 + gyro 3축)를 측정하여 그래프로 그립니다. 
- 그려진 데이터를 생성하여 CoreData와 json파일로 저장합니다.
- 저장한 데이터의 그래프를 확인해보거나 다시 재생해볼 수 있습니다.

#### 개발 기간
- 2023년 1월 30일(월) ~ 2023년 2월 5일(일)

## 🌱 팀 소개
|[Wonbi](https://github.com/wonbi92)|[Ayaan](https://github.com/oneStar92)|
|:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/88074999?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://i.imgur.com/Unq1bdd.png">|

## 🛠 실행 화면
|Accelerometer 측정|Gyro 측정|
|:-:|:-:|
![](https://i.imgur.com/O4DzDDH.gif)| ![](https://i.imgur.com/0c3pV7F.gif)

|측정 예외 사항 및 측정된 데이터 삭제|측정된 데이터 Detail 및 Play|
|:-:|:-:|
![](https://i.imgur.com/zqh3VTA.gif)|![](https://i.imgur.com/qIsSDFa.gif)


## 👀 Diagram
### 🧬 Class Diagram
**[Class Diagram 보러가기](https://miro.com/app/board/uXjVPsjIXrY=/?share_link_id=196015211001)**

### 🐙 기술스택 마인드맵
![](https://i.imgur.com/0lwalGu.png)

### 🏗 아키텍쳐
![](https://i.imgur.com/ofH8yjG.png)

## 🏃🏻 사용한 기술

#### ⚙️ MVVM 
- 💡 역할 간 계층을 분리를 통해 하나의 객체가 모든 책임을 다 가지도록 하지 않게 하고, 앱의 유지보수 및 수정을 편리하게 하기 위해 사용하였습니다.

#### ⚙️ Design Patten - FactoryMethod

- 💡 ViewController를 생성하는 책임을 분리하여, `ViewControllerFactory` 객체를 통해 ViewController 생성을 전담하도록 하였습니다.

#### ⚙️ Design Patten - Builder
- 💡 사용자에게 특정 정보를 알려주는 Alert을 만들어주는 `AlertBuilder` 객체를 통해 Alert을 생성 시 각 상황에 맞게 사용할 수 있도록 하였습니다.

 
## 🗂 폴더 구조


<details>
<summary> 
펼쳐보기
</summary>

```
GyroData
├── AppDelegate
├── SceneDelegate.swift
├── Info.plist
├── Scene
│   ├── GraphView
│   │   ├── GraphSegmentView
│   │   └── GraphView
│   ├── Motion
│   │   ├── MotionGraphViewController
│   │   └── MotionGraphViewModel
│   ├── MotionMeasure
│   │   ├── MotionMeasureViewController
│   │   └── MotionMeasureViewModel
│   ├── MotionsList
│   │   ├── MotionCell
│   │   ├── MotionsListViewController
│   │   └── MotionsListViewModel
│   └── Utility
│       ├── AlertBuilder
│       ├── AlertStlye
│       ├── Date+
│       ├── PlayButton
│       └── ViewControllerFactory
├── Domain
│   ├── Entity
│   │   └── Motion
│   ├── Service
│   │   ├── CoreDataMotionReadService
│   │   ├── FileManagerMotionReadService
│   │   ├── MotionCreateService
│   │   ├── MotionDeleteService
│   │   ├── MotionMeasurementService
│   │   └── Protocol
│   │       ├── CoreDataMotionReadable
│   │       ├── FileManagerMotionReadable
│   │       ├── MotionCreatable
│   │       ├── MotionDeletable
│   │       └── MotionMeasurable
│   └── Utility
│       ├── CMAcceleration+
│       ├── CMRotationRate+
│       └── MotionDataType
├── Repository
│   ├── CoreData
│   │   ├── DefaultCoreDataRepository
│   │   ├── Entity
│   │   │   ├── MotionMO+
│   │   │   ├── MotionMO+CoreDataClass
│   │   │   └── MotionMO+CoreDataProperties
│   │   └── Protocol
│   │       └── CoreDataRepository
│   ├── FileManager
│   │   ├── DefaultFileManagerRepository
│   │   ├── Entity
│   │   │   └── MotionDTO
│   │   └── Protocol
│   │       └── FileManagerRepository
│   └── Protocol
│       └── DomainConvertible
GyroDataTests
    └── ServiceTests
        ├── Common
        │   ├── CoreDataRepositoryMock
        │   └── FileManagerRepositoryMock
        ├── CoreDataMotionReadServiceTests
        ├── FileManagerMotionReadServiceTests
        ├── MotionCreateServiceTests
        └── MotionDeleteServiceTests
```
</details>

## ⏰ 타임라인

#### 👟 2023/01/30
- 기술스택 결정
    - ✅ 요구사항과 현재 상황에 가장 적합하다 판단되는 기술스택 결정
- 폴더 및 파일 구조 설정
- 프로젝트 기본 사항 설정

#### 👟 2023/01/31
- Model 구현
    - ✅ MotionDataType Protocol 구현
    - ✅ Motion 구현
    - ✅ CMRotationRate, CMAcceleration이 MotionDataType 채택
- Entity 구현
    - ✅ DomainConvertable Protocol 구현
    - ✅ MotionMO 구현
    - ✅ MotionDTO 구현
- Repository 구현
    - ✅ Repository Protocol 구현
    - ✅ CoredataRepository 구현
    - ✅ FileManagerRepository 구현

#### 👟 2023/02/01
- Service 구현
    - ✅ MotionDeletable Protocol 구현
    - ✅ CoreDataMotionReadable Protocol 구현
    - ✅ MotionCreatable Protocol 구현
    - ✅ FileManagerMotionReadable Protocol 구현
    - ✅ MotionDeleteService 구현
    - ✅ CoreDataMotionReadService 구현
    - ✅ MotionCreateService 구현
    - ✅ FileManagerMotionReadService 구현

#### 👟 2023/02/02
- Service 구현
    - ✅ MotionMeasurable Protocol 구현
    - ✅ MotionMeasurementService 구현

- ViewModel 구현
    - ✅ MotionListViewModel 구현
    - ✅ MotionListViewModelDelegate Protocol 구현
    - ✅ MotionMeasurementViewModel 구현
    - ✅ MotionMeasurementViewModelDelegate Protocol 구현
    - ✅ MotionViewModel 구현
    - ✅ MotionViewModelDelegate Protocol 구현

#### 👟 2023/02/03
- ViewController 구현
    - ✅ MotionsListViewController 구현
    - ✅ MotionGraphViewController 구현
    - ✅ MotionMeasureViewController 구현
    - ✅ GraphicView 구현

---

[⬆️ 맨 위로 이동하기](#-gyro-data)

