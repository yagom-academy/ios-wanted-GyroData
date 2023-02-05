# GyroData - README

## 목차
1. [프로젝트 소개](#-프로젝트-소개)
2. [실행 화면](#-실행-화면)
3. [프로젝트 구조](#-프로젝트-구조)
4. [고민한 점](#-고민한-점)
5. [참고 링크](#-참고-링크)

---

## 🪧 프로젝트 소개
기기의 가속도와 자이로스코프 데이터를 실시간으로 측정한 데이터를 그래프 형태로 보여주고, 측정한 데이터를 저장해서 다시 볼 수 있는 앱

### 개발환경 및 라이브러리

![Swift](https://img.shields.io/badge/Swift-5.7.2-orange) ![Xcode](https://img.shields.io/badge/Xcode-14.2.0-blue) ![iOS](https://img.shields.io/badge/iOS-14.0-green)

### 👥 팀원

|<img src=https://i.imgur.com/TVKv7PD.png width="150" height="150" >|<img src="https://camo.githubusercontent.com/a482a55a5f5456520d73f6c2debdd13375430060d5d1613ca0c733853dedacc0/68747470733a2f2f692e696d6775722e636f6d2f436558554f49642e706e67" width=160>|
|:--:|:--:|
|[summercat](https://github.com/dev-summer)|[junho](https://github.com/junho15)|


## 📱 실행 화면

|**리스트 화면**|**스와이프 메뉴**|
|:--:|:--:|
|<img src=https://i.imgur.com/gStohlk.png width="250">|<img src=https://i.imgur.com/oD4CRoR.png width="250">|
|**측정 화면**|**빈 데이터 저장 시 오류 alert**|
|<img src=https://i.imgur.com/1gn5J2p.gif width="250">|<img src=https://i.imgur.com/wGFRCBX.gif width="250">|
|**다시보기_ViewType**|**다시보기_PlayType**|
|<img src=https://i.imgur.com/YW37tlu.png width="250">|<img src=https://i.imgur.com/DCmyT1e.gif width="250">|

## 📂 프로젝트 구조

### UML

|![UML](https://github.com/dev-summer/ios-wanted-GyroData/blob/main/Images/GyroDataUML.png?raw=true)|
|:--:|

### File Tree

|![File Tree](https://i.imgur.com/CRDkvAn.png)|
|:--:|

## 🤔 고민한 점

### 문제 상황

* 실시간으로 그래프를 그릴 때, 데이터의 최대값이 변경되면 그래프의 이미 그려져 있는 부분을 비율에 맞게 축소해야 함.

### 해결 방법

1. 이미 그려진 부분의 레이어를 `transform`을 이용해서 축소시키고, 최대값이 변경된 부분부터 새로운 레이어에 그리는 방식. 
    * 장점
        * 기존 레이어 크기를 조정하면 되기 때문에 그래프를 다시 그릴 필요가 없어 성능상에 이점이 있음.
    * 단점
        * 로직이 복잡하고 구현하기가 어려움. 코드의 가독성이 좋지 않음.
2. 최대값이 변경되면 이미 그려진 그래프 부분을 비율에 맞게 다시 그려주는 방식
    * 장점
        * 그래프를 그리는 코드를 재활용할 수 있기 때문에 구현이 편리하고 코드의 가독성이 좋음.
    * 단점
        * 최대값이 자주 변경될 경우 성능적인 측면에서 비교적 불리함.

### 선택한 해결 방법과 이유

* 2번 방법을 선택함.
* `Render Loop`는 초당 120번(또는 60번) 프레임(기기 화면)을 업데이트 하지만, 데이터는 1/10초에 한 번씩 들어오기 때문에 실제로는 성능면에 큰 영향을 주지 않을 것 같아서 선택하게 되었습니다.

## 📎 참고 링크

* [CMMotionManager | Apple Developer Documentation](https://developer.apple.com/documentation/coremotion/cmmotionmanager)
* [FileManager | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/filemanager)
* [CAShapeLayer | Apple Developer Documentation](https://developer.apple.com/documentation/quartzcore/cashapelayer/)
* [Working with Files on iOS with Swift | Appypie](https://www.appypie.com/filemanager-files-swift-how-to/)
