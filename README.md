# 📱👋🏻 Gyro

## 🗒︎ 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원 소개 및 역할](#-팀원-소개-및-역할)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-UML)
7. [실행화면](#-실행-화면)
8. [구현내용](#-구현-내용)


<br>

## 👋 소개

**아이폰의 움직임(Acc,Gyro) 변화를 그래프화된 데이터로 관리해주는 프로젝트**
- 프로젝트 기간 : 23.01.30 ~ 23.02.05 (1주)

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![macOS](https://img.shields.io/badge/macOS_Deployment_Target-14.0-blue)]()

<br>

## 🧑 팀원 소개 및 역할

- **소개**


|Beam|Dragon|
|:---:|:---:|
|<img src="https://i.imgur.com/ucW98qR.png" width=200 height=200>|<img src = "https://i.imgur.com/LI25l3O.png" width=200 height=200>| 
| [Github](https://github.com/Dylan-yoon) | [Github](https://github.com/YongGeun2) |

<br>

- **역할**

| 공동 작업 | Baem 작업 | Dragon 작업 |
|:---:|:---:|:---:|
| `MainViewController` 구현 <br /> `GraphView` 구현 <br /> `CoreData-CRD` 기능 구현 <br /> `Dark&LightMode` 따른 구현 | `ReplayViewController` 구현 <br /> 데이터 View & Play 기능 구현 <br /> `DarkMode`에서 기능 검토| `AddViewController` 구현 <br /> 데이터 저장 기능 구현 <br /> `LightMode`에서 기능 검토|



<br>

## 🕖 타임라인

|날짜|구현 내용|
|--|--| 
|23.01.30| 프로젝트 일정 및 진행방향 수립 <br /> `Code`단에서 UI 구성할 수 있도록 세팅|
|23.01.31|`MainViewController` 생성 및 UI 구성 <br /> `AddViewController`, `ReplayViewController` 생성|
|23.02.01|`GraphView` 생성 및 기능 구현 <br /> `ReplayViewController` 타이머 적용 및 관련 기능 구현 <br /> `CoreData` 생성 및 CRD 기능 구현 (Update 기능 미사용)|
|23.02.02|`AddViewController`, `ReplayViewController` CoreData-CRD 기능 적용 <br /> `AddViewController` 타이머 적용 및 관련 기능 구현 |
|23.02.03|UI 요소 및 전체 구성을 깔끔하게 정리 <br /> `AddController` Alert 기능 추가|
|23.02.04|`Code` 리팩토링 및 정리|
|23.02.05|`Code`, 앱 동작 최종 검토 <br /> 프로젝트 README 작성|

<br>

## 💾 파일구조

### tree
```bash
.
├── GyroData
│   ├── Info.plist
│   ├── MotionDataModel.xcdatamodeld
│   ├── Resource
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   ├── LaunchScreen.storyboard
│   │   └── Assets
│   └── Source
│       ├── CoreData
│       │   ├── Motion+CoreDataClass.swift
│       │   └── Motion+CoreDataProperties.swift
│       ├── Model
│       │   ├── CoreDataError.swift
│       │   ├── CoreDataProcessible.swift
│       │   ├── MotionData.swift
│       │   └── MotionDataForm.swift
│       └── Scene
│           └── Main
│               ├── Add
│               │   └── AddViewController.swift
│               ├── MainViewController.swift
│               ├── Replay
│               │   └── ReplayViewController.swift
│               └── View
│                   ├── AlertPresentable.swift
│                   ├── CustomDataCell.swift
│                   └── GraphView.swift
└── README.md

```
<br>

## 📊 UML

2/5 일요일날 같이 작성해도 되고 안넣어도 될듯합니다.
(아니면 뱀이 작성해서 넣어주셔도 됩니다)

|<img src=이미지추가 width=700>|
|--|

<br>

## 💻 실행 화면
- 용량 문제로 저화질 파일 업로드

|<img src="https://i.imgur.com/kH2SYK3.gif" width=250>|<img src="https://i.imgur.com/XLZGBdl.gif" width=250>|<img src="https://i.imgur.com/0vHi1aU.gif" width=250>|
|:-:|:-:|:-:|
|Acc&Gyro 데이터 저장|데이터 View기능|데이터 Play기능|

|<img src="https://i.imgur.com/HmUFBZD.gif" width=250>|<img src="https://i.imgur.com/4FqfIt6.gif" width=250>|<img src="https://i.imgur.com/wO88A9Z.gif" width=250>|
|:-:|:-:|:-:|
|데이터 삭제|측정 미진행시 알림기능|데이터 재측정시 동작|

<br>

## 🎯 구현 내용

- **MVC 아키텍쳐**를 사용하여 구현

#### [파일 설명]
- **Controller**
    - MainViewController
        - 첫 화면의 UI 구성
            - 측정날짜, 측정기준(Acc&Gyro), 측정시간을 TableViewCell로 보여줌
    - AddViewController
        - 아이폰 움직임(Acc&Gyro) 데이터를 측정하는 화면의 UI 구성
            - 데이터를 측정한 후 측정날짜, 측정기준(Acc&Gyro), 측정시간와 함께 저장할 수 있음
    - ReplayViewController
        - 측정된 데이터를 View&Play 화면의 UI 구성
            - View모드
                - 저장된 모든 데이터를 그래프에 한번에 그려줌
            - Play모드
                - 실시간으로 저장된 데이터의 변화를 그래프 다시 그려줌
<br>

- **View**
    - GraphView
        - 아이폰의 움직임을 그래프로 표현해주는 View
    - CustomDataCell
        - `MainViewController` - `UITableView`에 사용되는 CustomCell
<br>

- **Model**
    - CoreDataProcessable
        - `CoreData` 사용을 위한 `Create, Read, Delete` 기능 구현 (`Update` 미사용으로 미구현)
    - CoreDataError
        - `CoreData` 사용시 발생하는 `Error`를 관리
    - MotionData
        - 아이폰 움직임의 `X,Y,Z축` 데이터를 가지는 구조체
    - MotionDataForm 
        - `측정기준(Acc&Gyro)``, `측정날짜`, `측정시간`, `측정데이터`를 가지는 구조체
    - AlertPresentable`
        - `Alert`를 생성할 수 있는 Protocol+Extension
