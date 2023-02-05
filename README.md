# 📊 Gyro Data
> 프로젝트 기간: 2023-01-30 ~ 2023-02-05 (1주)

## 🗒︎목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [파일구조](#-파일구조)
5. [UML](#-uml)

---

## 👋 소개
- 6축 데이터(acc 3축 + gyro 3축)를 다뤄보는 앱입니다.
- 데이터를 생성하여 CoreData와 json파일로 저장하고, 불러오는 앱입니다.

|분류|기술스택|
|:---|:---|
|UI|UIKit|
|Local DB|Core Data|
|App 아키텍쳐|MVVM|

---

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.7-orange)]()
[![iOS](https://img.shields.io/badge/iOS_Deployment_Target-14.0-blue)]()

---

## 🧑 팀원
|애쉬|som|
|:---:|:---:|
|<img src= "https://avatars.githubusercontent.com/u/101683977?v=4" width ="200">|<img src = "https://i.imgur.com/eSlMmiI.png" width=200 height=200>|

---

## 💾 파일구조
```
GyroData
├── GyroInformation+CoreDataClass
├── GyroInformation+CoreDataProperties
├── Commom
│   ├── Extension
│   │   ├── Data +
│   │   └── CGContext +
│   ├── Manager
│   │   ├── CoreDataManager
│   │   ├── FileManager
│   │   └── MeasurementManager
│   ├── Observable
│   ├── Measurable
│   ├── CoordinateData
│   ├── GraphMode
│   └── MotionMode
├── Model
│   ├── GyroInformationModel
│   └── GyroData
├── View
│   ├── ListViewController
│   ├── MeasurementViewController
│   ├── ReplayViewController
│   ├── ListTableViewCell   
│   └── GraphView
│       ├── GraphSegment
│       ├── GraphView
│       └── GraphContent
└── ViewModel
    ├── ListViewModel
    ├── MeasurementViewModel
    └── ReplayViewModel
```

---

## 📊 UML
![](https://i.imgur.com/iILaupN.jpg)


---
