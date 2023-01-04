# 🗂 Gyro Data 프로젝트

## 📘 목차
- [👩‍💻 프로젝트 및 개발자 소개👨‍💻](#-프로젝트-및-개발자-소개)
- [⚙️ 개발환경 및 라이브러리](#%EF%B8%8F-개발환경-및-라이브러리)
- [🟦 프로젝트 로고](#-Gyro-Data-프로젝트-로고)
- [❇️ 핵심 키워드](#-키워드)
- [📱 구현 화면](#-구현-화면)
- [👩🏻‍ 코드 설명](#-코드-설명)
- [📁 폴더 구조](#-폴더-구조)
- [⚡️ 트러블 슈팅](#%EF%B8%8F-트러블-슈팅)
- [🔗 참고 링크](#-참고-링크)


<br>

## 📜 프로젝트 및 개발자 소개
> **소개** : 6축 데이터(acc 3축 + gyro 3축)를 다뤄보고, 데이터를 생성하여 CoreData와 json파일로 저장하고, 불러오는 앱입니다.<br>**프로젝트 기간** : 2022.12.26 ~ 2022.12.30<br>

| **[엘렌(Ellen)](https://github.com/jcrescent61)** | **[언체인(Unchain)](https://github.com/unchain123)** | **[예톤(Yeton)](https://github.com/yeeton37)** |
|:---:|:---:|:---:|
|<img src="https://i.imgur.com/s7IBwC1.jpg" width="270" height="250"/>|<img src="https://i.imgur.com/I4RtOVg.png" width="270" height="250"/>|<img src="https://i.imgur.com/5cHjgY4.jpg" width="270" height="250"/>|

### 엘렌(Ellen)
- MVVM 아키텍처 구조 설계
- 측정 및 플레이 로직 구현
- AnalysisView 측정 화면 구현

### 언체인(unchain)
- 그래프뷰 구현
- SwiftUI와 UIKit 데이터 바인딩
- 메인화면 구현

### 예톤(Yeton)
- 코어데이터 구현
- 파일매니저 구현
- PlayView 구현

<br>

## ⚙️ 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5-orange)]() [![xcode](https://img.shields.io/badge/Xcode-14.2-blue)]() [![img](https://img.shields.io/badge/CoreData-red)](https://firebase.google.com/products/firestore?hl=ko) [![FileManager](https://img.shields.io/badge/FileManager-yellow)]()

<br>

## 🟦 Gyro Data 프로젝트 로고

<img src="https://i.imgur.com/drLuvoF.png" width="270" height="250"/>

## 💡 키워드

- **`Combine`**
- **`FileManager`**
- **`SwiftUI`**
- **`Charts(SwiftUI)`**
- **`CoreData`**
- **`MVVM`**
- **`UITableView`**
- **`GraphView`**
- **`DataFormatting`**
- **`SwiftUI + Combine`**
- **`UIKit`**
<br>

## 📱 구현 화면

|**메인 화면** | **측정 화면** | 
| -------- | -------- |
|![](https://i.imgur.com/mUKJ5s3.gif)| ![](https://i.imgur.com/17Hyo3a.gif)|

<br>

| Play 화면 | View 화면 | 
| -------- | -------- |
| ![](https://i.imgur.com/OEqRGZg.gif) | ![](https://i.imgur.com/EsIpraY.gif) |



<br>

**FileManager 저장**
- 그래프를 그려주는 모델을 저장
- file url 경로를 타고 들어가면 아래와 같은 파일이 생성되어 있음

<img src="https://i.imgur.com/u09xI0C.png" width="600"/>


**CoreData 저장**
- 테이블 뷰 셀을 그려주는 모델을 CoreData에 저장



<br>


## 👩🏻‍💻 코드 설명

<details>
<summary> CoreData </summary>
	
- `GraphFileManager` : File에 json 데이터 형태로 그래프 관련 데이터를 저장하는 FileManager Manager  
- `CoreDataManager` : CoreData에 key value 형태로 셀 관련 데이터를 저장하는 CoreData Manager
<br>
</details>

<br>

<details>
<summary> Model </summary>
	
- `CellModel` : Cell에 보여지는 모델 타입
- `GraphModel` : Graph에 보여지는 모델 타입
- `AnalysisType` : Acc와 Gyro 타입을 선택할 수 있는 enum 
	
</details>

<br>

<details>
<summary> Manager </summary>
	
- `AnalysisManager` : 측정을 시작하고 종료하는 메서드를 관리하는 타입
	
</details>

<br>

<details>
<summary> Domain </summary>
	
- `GraphRecordViewModel`: 그래프와 관련된 모델을 전달받아 뷰컨트롤러에 전달해주는 뷰 모델
- `GraphRecordViewController`: 일반 View와 Play View를 조건에 맞게 화면에 보여주는 뷰 컨트롤러
- `AnalyzeListViewController`: 첫 번째 화면, 측정이 완료되면 기록되는 테이블 뷰를 가지고 있는 뷰 컨트롤러
- `AnalyzeListViewModel`: 셀에 보여줄 데이터를 전달해주는 뷰 모델
- `AnalysisTableViewCell`: 테이블 뷰에 보여질 오토레이아웃과 요소들을 설정한 셀
- `HostingViewController`: SwiftUI의 뷰와 UIKit의 코드를 연결해주기 위해 생성한 뷰 컨트롤러
- `AnalyzeViewController`: 측정 버튼을 누르면 그래프가 실시간으로 측정되어 그려지는 화면을 보여주는 뷰 컨트롤러
- `AnalyzeViewModel`: 측정된 값을 코어데이터에 저장하는 뷰 모델
    
</details>

<br>

<details>
<summary> Extension </summary>

- `UIColor+`: 자주 사용되는 색을 지정할 수 있도록 확장
- `UIView+` : 뷰컨트롤러에 뷰를 추가하는 기능을 확장
- `Date+`: DateFormatter를 사용하여 날짜 형식 기능 확장

</details>

<br>

<details>
<summary> SupportFile </summary>

- `GyroData`: CoreData에 존재하는 Entity 타입

	
</details>
	
<br>


## 📁 폴더 구조
```
.
├── AppDelegate.swift
├── CoreData
│   ├── CoreDataManager.swift
│   └── GraphFileManager.swift
├── Domain
│   ├── Analyze
│   │   ├── AnalyzeViewController.swift
│   │   ├── AnalyzeViewModel.swift
│   │   └── HostingViewController.swift
│   ├── GraphView.swift
│   ├── Record
│   │   ├── GraphRecordView.swift
│   │   └── GraphRecordViewModel.swift
│   └── TableView
│       ├── AnalyzeListViewController.swift
│       ├── AnalyzeListViewModel.swift
│       └── Cell
│           └── AnalysisTableViewCell.swift
├── Extension
│   ├── UIColor+.swift
│   ├── UIDate+.swift
│   └── UIView+.swift
├── Manager
│   └── AnalysisManager.swift
├── Model
│   └── AnalysisType.swift
├── SceneDelegate.swift
├── SupportFile
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── GyroData.xcdatamodeld
│   │   └── GyroData.xcdatamodel
│   │       └── contents
│   └── Info.plist
└── ios-wanted-GyroData.txt
```

## ⚡️ 트러블 슈팅

### 1. UIKit과 SwiftUI의 Charts의 데이터 바인딩
 처음 과제를 받고 차트를 그리려고 할 때 올해 **WWDC**에서 보았던 **SwiftUI Charts**가 생각이 났습니다. 
 iOS16에서 사용할 수 있는 신 기술이기도 해서 한번 적용해보고 싶은 마음에 SwiftUIView를 그려서 **UIHostingViewcontroller**를 이용하여 사용했습니다. charts를 사용하여 만든 그래프뷰에 데이터가 바로 반영이 되지않는 트러블이 일어났습니다. 컴바인을 사용했기 때문에 데이터 바인딩이 잘 됐을거라고 판단을 했었지만 그것은 UIKit의 관점에서는 당연했지만 SwiftUIView는 프로퍼티레퍼로 바인딩된 데이터에만 뷰를 새로 그리기 때문에 다른방법을 찾아야 했습니다.
 처음에는 ObservableObject를 이용하여 바인딩을 시도 했었는데 어떤 이유에선지 바인딩이 잘 되지 않았고 Environmentobject를 활용하기로 했습니다. 일반적인 데이터의 전달은 ObservableObject를 이용 하지만 모든 뷰가 동일 한 모델을 가리키고 데이터의 변화에 즉시 업데이트가 필요한 경우에 사용하게 됩니다. **Environmentobject**의 장점이 데이터의 변경에 따라 어떤 부분이든 동기화를 보장 한다는 것이기 때문입니다.

### 2. 단방향 구조의 MVVM 설계

<img src="https://i.imgur.com/3kUJ679.png" width="600"/>

데이터 흐름을 오직 **단방향**으로 흐르게 구현했습니다. 데이터 흐름이 단순하여 새로운 기능이 추가되어도 리팩토링에 용이합니다. 또한 Swift의 **프로토콜 프로그래밍 패러다임**을 채택하여 ViewModel의 Input 시그널과 Output 시그널 모두를 Protocol을 사용하여 인터페이스화 했습니다.

<br>

### 3. Model 타입에 대한 고민

처음 Model을 구상하였을 때에는 Model 내부 프로퍼티의 타입에 아래와 같이 Core Data에서 제공하는 기본 타입이 아닌 커스텀한 타입이 존재했습니다. 

```swift
struct GyroDataModel: Codable {
    let id: UUID
    let analysisType: AnalysisType
    let savedAt: [Date]
    let measurementTime: Double
}
```

커스텀 한 타입인 `AnalysisType, [Date]` 등을 **Core Data**에 넣어주고자 했으나 이미 만들어진 entity와 파일을 수정하는 것에 어려움을 겪었습니다. 
그래서 `아이폰 앱마다 존재하는 공간을 관리하는 매니저`인 **FileManager**를 사용하는 방식을 추가하였습니다.

결론적으로 **CoreData**는 `셀에 보여지는 기본적인 타입을 저장`하는 데 사용했고, **FileManager**는 `아이폰 앱 내부 경로에 json 형태로 커스텀 한 타입을 저장`할 때 사용하여 두 가지 방식을 모두 채택하였습니다. 


## 🔗 참고 링크


- [FileManager](https://leeari95.tistory.com/32)
- [FileManager](https://developer.apple.com/documentation/foundation/filemanager)
- [Combine](https://developer.apple.com/documentation/combine)
- [Charts](https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts)
- [environmentobject를 사용해서 데이터 바인딩](https://www.hackingwithswift.com/quick-start/swiftui/whats-the-difference-between-observedobject-state-and-environmentobject)
