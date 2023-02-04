# 📈 자이로 App ![iOS badge](https://img.shields.io/badge/Swift-F05138?style=flat&logo=Swift&logoColor=white) ![iOS badge](https://img.shields.io/badge/iOS-14.0%2B-blue)

> 👩🏻‍💻 2023.01.30~ 2023.02.04

**유저의 모바일기기의 실시간 자이로, 가속도를 측정하는 애플리케이션입니다.**
- 0.1초 단위로 최대 60초까지 측정할 수 있습니다.
- 측정 값의 X, Y, Z 축 변화를 실시간으로 변하는 그래프로 보여줍니다.
- 저장 된 데이터로 그래프 애니메이션을 재생하거나 최종 결과 그래프로 볼 수 있습니다.

---

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [개발환경 및 적용기술](#-개발환경-및-적용기술)
4. [Class Diagram](#-class-diagram)
5. [폴더 구조](#-폴더-구조)
6. [타임라인](#-타임라인)
7. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
8. [고민한 부분](#-고민한-부분)
9. [참고 링크](#-참고-링크)

---

## 🌱 팀 소개


<table>
	  </tr>
	<tr>
	 <td style="text-align:center" > <a href="https://github.com/sunny-maeng">써니쿠키</a>  </td>
			 <td style="text-align:center" > <a href= "https://github.com/yuvinrho"> 로빈  </td>
  </tr>
  <td style="text-align:center" > <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/107384230?v=4"> </td>
			 <td style="text-align:center" > <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/49301866?v=4"> </td>
  	  </tr>
	<tr>
	 <td style="text-align:center" >  - 데이터목록 화면 View와 Logic 담당 <br> - 다시보기 화면 View 담당 <br> - CoreData를 통한 데이터 관리 <br> - 데이터 핸들링 Error처리 <br> - GraphView MVVM 디자인패턴 적용  </td>
			 <td style="text-align:center" >  - 측정화면 View와 Logic 담당 <br> - 다시보기 화면 Logic 담당 <br> - 자이로, 가속도 측정 <br> - 그래프 그리기 <br> - FileManager를 통한 데이터 관리  </td>
  </tr>
  
  
  <tr>
	 <td colspan= "2"> <strong>  공통기여 </strong>  </td>
  </tr>
	<tr>
	 <td colspan= "2" style="text-align:center" >  - Model타입 협의 구현 <br> - 측정한 데이터 비동기로 저장  </td>

</table>

---

## 📱 기능 소개
### 1. Main 화면
- 자이로, 가속도 측정데이터 리스트 화면입니다.
- 저장된 데이터를 10개씩 불러와서 보여줍니다.


|메인 화면|페이징 구현|
|:-:|:-:|
|<img src="https://i.imgur.com/U3LVbkv.png" width="200" height="400"/>|<img src="https://i.imgur.com/3Espvcq.gif" width="200" height="400"/>|


### 2. 가속도, 자이로 측정화면
- 세그먼트 컨트롤러에서 Accelerometer, Gyro 센서를 선택한 후 측정버튼을 누르면 0.1초 단위로 측정한 데이터를 그래프에 보여줍니다.
- 최대 1분 동안 데이터를 측정할 수 있습니다.
- 저장버튼을 누르면 측정한 결과는 CoreData, FileManager를 이용해 디바이스에 저장됩니다.
- 저장시 Activity Indicator를 표시합니다.
- 저장실패시 알람을 표시합니다.

|가속도 측정|자이로 측정|
|:-:|:-:|
|<img src="https://i.imgur.com/Cgq7hAh.gif" width="200" height="400"/>|<img src="https://i.imgur.com/j7hV3HY.gif" width="200" height="400"/>|



|저장 성공|저장 실패|
|:-:|:-:|
|<img src="https://i.imgur.com/uzVadZu.gif" width="200" height="400"/>|<img src="https://i.imgur.com/jggWbFZ.gif" width="200" height="400"/>|


### 3. 저장한 자이로, 가속도 측정결과 그래프화면
- 저장한 데이터를 그래프로 확인할 수 있습니다.
- 메인 화면에서 셀을 터치하면 그래프를 확인할 수 있습니다.
- 셀을 스와이프하여 Play버튼을 누르면 그래프를 리플레이해서 확인할 수 있습니다.

|그래프|그래프 리플레이|
|:-:|:-:|
|<img src="https://i.imgur.com/raGTBZm.gif" width="200" height="400"/>|<img src="https://i.imgur.com/JlbLfgt.gif" width="200" height="400"/>|


### 4. 다크모드 지원
- 사용자를 위해 다크모드를 지원합니다.

|메인화면|측정하기 화면|그래프 화면|
|:-:|:-:|:-:|
|<img src="https://i.imgur.com/xY5fwO5.png" width="200" height="400"/>|<img src="https://i.imgur.com/zqgWR1P.png" width="200" height="400"/>|<img src="https://i.imgur.com/i22rieg.gif" width="200" height="400"/>|


---

## 🛠 개발환경 및 적용기술
![iOS badge](https://img.shields.io/badge/Swift-V5.7-red) ![iOS badge](https://img.shields.io/badge/Xcode-V14.2-blue)

| UI | 데이터 저장 |  아키텍처  |
| :--------: | :--------: | :--------: |
| <img height = 90, src = "https://i.imgur.com/q6rTXrE.png">     | <img height = 90, src = "https://i.imgur.com/DSnI74h.png">   <img height = 90, src = "https://i.imgur.com/p6nJlhN.png">    | <img height = 70, src = "https://i.imgur.com/FWud4LR.png">     <img height = 70, src = "https://i.imgur.com/TY8lr5s.png"> 
| UIKit <br> (Only Code) | CoreData / FileManager | MVC + 부분 MVVM |


- **MVC 채택 이유**
	-  MVC패턴은 가장 빠르게 구현할 수 있는 모델로 Model, View, Controller 관심사를 분리하여 유지보수를 쉽게 할 수 있다고 생각해 채택했습니다.
	-  MVC패턴은 흔히 말하는 `Massive한 ViewController`가 될 수 있는 단점이 있지만 현재 프로젝트는 한 개의 화면에서 담당하는 로직이 많지 않다고 판단했습니다.

- **MVVM 적용 이유**
	- 그래프를 그리는 GraphicView는 `BezierPath`를 이용해 실시간으로 뷰를 없데이트 해야하는데, `Model`을 직접 가지고 그래프를 그리는게 용이하다 판단해 `ViewModel`을 적용했습니다.

---

## 👀 Class Diagram

### 👉 MVC + 부분 MVVM
 
|![](https://i.imgur.com/IM5jq8B.jpg)|
|---|

### 👉 DataStorage 계층구조

|<img width = 500, src ="https://i.imgur.com/Dm9Q1HU.png">|
|---|

---

## 🗂 폴더 구조
```
GyroData
├── Views
│   ├── LineGraphView
│   ├── ListCell
│   ├── ListView
│   ├── MeasurementView
│   └── ReviewView
│
├── Controllers
│   ├── ListViewController
│   ├── MeasurementViewController
│   └── ReviewViewController
│
├── Models
│   ├── AxisValue
│   ├── Measurement
│   ├── Sensor
│   └── SensorManager
│
├── Extension +
│   ├── Date +
│   ├── JSONDecoder +
│   ├── JSONEncoder +
│   ├── UIAlertController +
│   ├── UILabel +
│   └── UIStackView +
│
├── DataStorage
│   ├── DataHandleableProtocol
│   ├── DataHandleError
│   ├── CoreData
│   │   ├── CoreDataManager+DataHandleable
│   │   └── MeasurementCoreModel
│   └── FileManager
│       └── SensorFileManager
│
└── Supporting Files
    ├── AppDelegate
    ├── SceneDelegate
    ├── Base.lproj
    │   └── LaunchScreen.storyboard
    ├── Info.plist
    └── Assets.xcassets

```

---

## ⏰ 타임라인

### 🕛 Step1 - (총 2일) 2023.01.30 ~ 2023.01.31
|   | 진행 내용 |
| :--------: | -------- |
| 1 | Model 협의 및 생성 |
| 2 | `ListView` 그리기 및 `ListViewController` 로직 구현 | 
| 3 | `MeasurementView` 그리기 및 `MeasurementViewController` 로직 구현 |


### 🕒 Step2 - (총 4일) 2023.02.01 ~ 2023.02.04
|   | 진행 내용 |
| :--------: | -------- |
| 1 | 데이터 처리 타입 구현 및 적용 - `CoreDataManager`, `SensorFileManager` 생성 |
| 2 | `ReviewPageView` 그리기 및 `ReviewPageViewController` 로직 구현 |
| 3 | 데이터 처리 중 Error 발생 Alert 처리 |

---

## 📝 프로젝트에서 경험하고 배운 것

- [X] CoreData를 이용한 TableView Paging  
	 - `scrollView Delegate`와 `offset`을 사용해 테이블뷰 마지막 스크롤 지점을 확인할 수 있습니다. 
	 - CoreData의 `fetchLimit`, `fetchOffset`를 사용해 10개씩 데이터를 가져 올 수 있습니다.
- [X] CoreMotion을 이용한 센서(자이로, 가속도)측정
    - `CoreMotion`과 `Timer`를 이용하여 설정한 interver마다 데이터를 측정하고 타임아웃이 되면 측정을 정지합니다.
- [X] `FileManager`를 이용해 측정한 데이터 디바이스에 저장
    - 측정화면에서 저장 버튼을 누르면 디바이스에 json파일로 저장합니다.

---

## 💭 고민한 부분

### 1️⃣ 추후에 데이터양이 많아져 데이터처리 기술스택이 변경될 때 수정의 용이함 고려
현재는 데이터 처리를 `CoreData`와 `FimeManager`를 사용하고 있습니다.
추후에 데이터양이 많아져 서버에 저장해야한다던가, 데이터베이스 기술스택이 변경될 때 수정이 용이하도록 하고 싶었습니다.

그래서 `DataHandleable`로 프로토콜 추상화했습니다. 이 프로토콜은 `DataType`을 `associatedtype`으로 지정해서 사용할 수 있습니다. 그리고 데이터 처리에 필요한 CRUD 중 현재 프로젝트에서 필요한 데이터 저장(Create), 데이터 가져오기(Read), 데이터 삭제(Delete) 메서드를 필수구현 메서드로 선언되어있습니다. 

저희 프로젝트에서는 `Measurement`구조체(DTO)를 이용해 데이터를 다루고 고있기 때문에 프로토콜 상속을 이용해 `DataType`을 `Measurement`로 사용하는 `MeasurementDataHandleable` 프로토콜을 생성했고, `CoreData`와 `FimeManager`를 관리하는 `Class`에서 `MeasurementDataHandleable`프로토콜을 채택하도록 했습니다.

로직 중, CRUD 메서드로 데이터를 처리해야할 때, 추상화타입인`MeasurementDataHandleable`의 메서드를 사용하도록 구현해 놓아서 추후 데이터처리 기술스택이 변경되더라도 이 프로토콜을 채택해 CRUD로직을 구현하고, 인스턴스만 갈아 끼워준 후 사용할 수 있습니다.

### 2️⃣ 측정한 데이터 저장시 Activity Indicator 표시
측정화면에서 저장버튼을 누르면 `Activity Indicator`가 화면에 나오면서 비동기로 저장되게 구현하였습니다.

이 과정에서 `Activity Indicator`가 보이지 않고 바로 저장되는 문제가 있습니다.

해당 문제는 아래와 같이 @escaping closure를 이용하여 `storeDataInDevice` 메서드가 끝나면 `Activity Indicator`가 멈추도록 하여 해결하였습니다.

```swift
startActivityIndicator()
storeDataInDevice {
    self.stopActivityIndicator()
    DispatchQueue.main.async {
        self.navigationController?.popViewController(animated: false)
    }
```

### 3️⃣ Error가 발생하면 User가 앱의 상태를 알 수 있도록 Alert 처리
저장된 측정값들을 불러오거나 측정한 값을 저장하고 삭제할 때 발생할 수 있는 `Error`들을 `DataHandleError` 열거형으로 정리하고, Error의 `localizedDescription`을 `overriding` 했습니다.

Error가 발생하면 "Error" `Alert`을 띄어주고, `overriding`한 localizedDescription을 Alert의 `Message`로 사용해 유저가 앱의 상황을 알 수 있도록 구현했습니다.

| ![](https://i.imgur.com/N8y9PGZ.png)     | ![](https://i.imgur.com/j3RIuJv.png)     | ![](https://i.imgur.com/zGQ8hph.png)     |
| -------- | -------- | -------- |

---

## 🔗 참고 링크

[공식문서]
- [Developer - Article: Getting Raw Gyroscope Events](https://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events)
- [Developer - Core Motion](https://developer.apple.com/documentation/coremotion)
- [Developer - Core Data](https://developer.apple.com/documentation/coredata)
- [Developer - FileManager](https://developer.apple.com/documentation/foundation/filemanager)
- [Developer - Article: About Apple File System](https://developer.apple.com/documentation/foundation/file_system/about_apple_file_system)
