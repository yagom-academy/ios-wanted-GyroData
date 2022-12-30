[![Swift 5.7](https://img.shields.io/badge/swift-5.7-ED523F.svg?style=flat)](https://swift.org/download/) [![Xcode 14.1](https://img.shields.io/badge/Xcode-14.1-ED523F.svg?style=flat&color=blue)](https://swift.org/download/)

# GyroData

> 6축 데이터(acc 3축 + gyro 3축)를 다뤄보는 앱

## 💻 개발자 소개

|우롱차|아리|
|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/43274246?v=4" width="200">|<img src="https://avatars.githubusercontent.com/u/75905803?v=4" width="200">|

## 목차

* [파일 디렉토리 구조](#-파일-디렉토리-구조)
* [기술 스택](#-기술-스택)
* [기능 및 UI](#-기능-및-ui)
* [설계 및 구현](#-설계-및-구현)
* [실행 화면](#-실행-화면)
* [기술적 도전](#-기술적-도전)
    * [Coordinator](#coordinator)
    * [Core Motion](#core-motion)
* [Truoble Shooting](#-truoble-shooting)
    * [CoreData로 fetch를 할 때, 특정 데이터만 가져오기](#coredata로-fetch를-할-때-특정-데이터만-가져오기)
    * [그래프 그리기](#그래프-그리기)
* [고민했던 점](#-고민했던-점)
    * ['측정' 화면은 modal 형태로 보여주는게 맞지 않을까?](#측정-화면은-modal-형태로-보여주는게-맞지-않을까)
    * [그래프를 그릴 때, 선이 그리드를 넘어간다면...](#그래프를-그릴-때-선이-그리드를-넘어간다면)
    * [데이터 구조](#데이터-구조)

## 🗂 파일 디렉토리 구조
```
  GyroData
 ├── Resources
 │   ├── Assets.xcassets
 │   └── Base.lproj
 └── Sources
     ├── App
     ├── Extension
     │   └── UI
     ├── Model
     ├── Presentation
     │   ├── Coordinators
     │   ├── MotionList
     │   │   ├── Coordinator
     │   │   ├── ViewControllers
     │   │   ├── ViewModels
     │   │   └── Views
     │   ├── MotionMeasure
     │   │   ├── ViewControllers
     │   │   ├── ViewModels
     │   │   └── Views
     │   └── MotionPlay
     │       ├── ViewControllers
     │       └── ViewModels
     └── Utility
         └── CoreDataStorage
             └── MotionStorage
                 └── EntityMapping
```

&nbsp;

## 🛠 기술 스택

* Swift/UIKit

### 아키텍처

* MVVM
* Coordinator

&nbsp;

### 데이터 및 UI 이벤트 처리

* `Observable`을 구현하여 뷰 바인딩 처리
* ViewModel의 View 관련 타입에 Observer를 등록할 수 있는 타입을 구현
    * `Observable`
        * 버튼 탭 이벤트 같은 Input이 들어왔을 때 적절한 Output을 내보낼 수 있도록 함
        * block에는 데이터 변경이 일어날 때 마다 view를 업데이트 할 수 있는 함수를 등록한다.
        * ViewModel 변경시에는 해당 observer가 실행되어 뷰도 그에 맞게 업데이트 된다.

&nbsp;

### 로컬 데이터 저장

* CoreData
* FileManager

&nbsp;

### 모션 데이터 측정

* CoreMotion

&nbsp;


## 📱 기능 및 UI

|기능/UI|설명|
|:-|:-|
|목록|측정하기 기능을 통해 로컬에 저장된 Motion 데이터를 가져와 리스트 형태로 보여준다.|
|측정|측정 버튼을 통해 Acc 혹은 Gyro 모션을 측정하여 실시간으로 그래프를 보여준다.|
|View|목록에서 셀을 터치하여 진입할 수 있고, 측정했던 데이터를 그래프 형태로 보여준다.|
|Play|목록에서 셀을 스와이프하여 진입할 수 있고, 측정했던 데이터를 그래프 형태로 보여준다. 재생버튼을 통해 그래프를 실시간으로 그려주기도 한다.|

&nbsp;

## 💻 설계 및 구현

### MVVM + Coordinator 구조

![](https://i.imgur.com/8qxKASW.png)

&nbsp;

### 역할 분배

|class/struct|역할|
|:-|:-|
|`AppCoordinator`|앱의 루트. 첫 화면을 준비하기 위한 타입|
|`MotionListCoordinator`|목록 화면의 화면 전환을 담당하는 타입|
|`MotionListViewController`|모션 데이터를 측정했던 기록들을 리스트 형태로 보여준다.|
|`MotionDetailViewController`|측정했던 데이터를 그래프 형태로 상세하게 보여준다. 두가지 모드로 구성되어있고, View와 Play 모드가 있다.|
|`MeasurementViewController`|모션을 측정할 수 있는 데이터다. 측정을 마치고나면 측정한 데이터를 로컬과 기기에 모두 저장할 수 있다.|


&nbsp;

### Utilities
|class/struct|역할|
|:-|:-|
|`CoreDataMotionStorage`|모션데이터를 관리하는 로컬저장소 타입|
|`CoreMotionManager`|모션을 측정할 수 있는 타입|
|`MotionFileManager`|측정한 모션 데이터를 저장, 삭제, 불러오기를 담당하는 타입|
|`Observable`|ViewModel의 각 데이터 타입에 Observer 기능을 구현하기 위한 제네릭 타입|

&nbsp;


## 👀 실행 화면

> 목록 화면

<img src="https://i.imgur.com/TtyvZe2.png" width="30%"> <img src="https://i.imgur.com/WMAW1a5.png" width="30%">

&nbsp;

> 측정하기

<img src="https://i.imgur.com/m32Nal1.png" width="30%"> <img src="https://i.imgur.com/BMVtvAK.png" width="30%">

&nbsp;

> 상세 화면

<img src="https://i.imgur.com/157ceZ0.png" width="30%"> <img src="https://i.imgur.com/j9CVAY1.png" width="30%">

&nbsp;

## 💪🏻 기술적 도전

### Coordinator

화면 전환에 대한 로직을 ViewController로부터 분리하고 의존성 객체에 대한 주입을 외부에서 처리하도록 하기 위해 코디네이터를 적용했습니다.

&nbsp;

### Core Motion

사용자로부터 accelerometer(가속도계), gyroscope(자이로) 정보를 가져오기 위하여 사용하였습니다.

&nbsp;

## 🔥 Truoble Shooting

### CoreData로 fetch를 할 때, 특정 데이터만 가져오기

* `문제 상황` 일반적인 fetch를 통해 로컬 데이터를 불러오게 되면, 저장되어있는 모든 데이터들을 가져오게 된다. 하지만 요구사항에 맞춰 10개의 데이터만 불러오고 이후 일정 이상 스크롤을 하게 되면 다음 데이터를 불러와야했다.
* `고민` 그래서 fetch를 할 때, 조건을 넣을 수 있는지 찾아보았다.
* `해결` 알아보니 fetch를 보낼 때 request를 파라미터로 전달하여 fetch를 진행하는데, 이때 request의 속성을 활용하여 특정 데이터만 fetch할 수 있었다.
* 그래서 아래와 같이 fetchLimit와 fetchOffset을 활용하여, 파라미터로 page가 들어왔을 때, 계산하여 특정 데이터만 불러올 수 있도록 메소드를 만들어주었다.
```swift
request.fetchLimit = 10
request.fetchOffset = Int(page * 10) - 10
```


### 그래프 그리기
수집한 데이터로부터 그래프를 그릴때 수집되는 값이 너무 작아 일정비율로 증폭시켜 그래프를 그렸습니다.

&nbsp;

## 😵‍💫 고민했던 점

### '측정' 화면은 modal 형태로 보여주는게 맞지 않을까?

측정 화면이 나타날 때, 네비게이션 push 형태로 화면 전환을 해달라는 요구사항이 있었습니다. 하지만 저희 생각에는 네비게이션이 아니라 모달로 띄워야하는게 맞지 않나 싶었습니다. (휴먼 인터페이스 가이드에 따르자면...?) 혹시나해서 크루에게 질문했는데, 요구사항에 맞춰 개발해달라고 하셔서 모달로 구현해두었던 측정 화면을 다시 네비게이션으로 재수정 하였습니다.

&nbsp;

### 그래프를 그릴 때, 선이 그리드를 넘어간다면...

두가지 해결방안을 생각하였습니다. 첫번째는 화면 비율을 줄이는 방식, 두번째는 최대값을 넘어간 값은 최대값으로 그리는 방식. 첫번째 방식을 시도하였고 화면비율을 줄이는 방식에 성공하였으나 줄여진 화면비율에서 좌표를 다시 계산하는 방식이 녹록치않아 두번째 방식을 선택하였습니다.

&nbsp;

### 데이터 구조

먼저 데이터가 저장되는곳이 두곳입니다.(CoreData, FileManager) 이 두곳에 저장될 데이터를 최대한 중복을 피해서 저장하고 싶었습니다. 그래서 CoreData에는 첫화면에 필요한 정보를 위주로 구성하였고 FileManager에는 그래프에 필요한 데이터를 저장하였습니다.

&nbsp;

 
