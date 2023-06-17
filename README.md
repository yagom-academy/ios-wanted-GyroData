# 📟 GyroData

> acc 3축 + gyro 3축 데이터를 측정하고 관리하는 앱입니다.
> 
> 프로젝트 기간: 2023-06-12 ~ 2023-06-17
>
> 소스 코드: [develop branch](https://github.com/kokkilE/ios-wanted-GyroData/tree/develop)


</br>

## ⭐️ 팀원
| kokkilE |
| :---: |
| <Img src = "https://hackmd.io/_uploads/SJL_ZRGw2.jpg" height=300> |
| [Github Profile](https://github.com/kokkilE) |

</br>

## 💻 개발환경 및 라이브러리
<img src = "https://img.shields.io/badge/swift-5.8-orange"> <img src = "https://img.shields.io/badge/Xcode-14.3-orange"> <img src = "https://img.shields.io/badge/Minimum%20Deployments-14.0-orange">

### 적용 프레임워크
<img src = "https://img.shields.io/badge/Foundation--green">
<img src = "https://img.shields.io/badge/UIKit--green"> <img src = "https://img.shields.io/badge/Combine--green"> <img src = "https://img.shields.io/badge/CoreData--green">  <img src = "https://img.shields.io/badge/CoreMotion--green">

</br>

## 📝 목차
1. [타임 라인](#-타임-라인)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 기능](#-구현-기능)
4. [아쉬운 점](#-아쉬운-점)
5. [참고 링크](#-참고-링크)

</br>

# 📆 타임라인
| 일자 | <center>구현 내용 |
| :---: | --- |
| 23.06.12(월) | - 요구사항 분석 </br> - 데이터 모델 구현 </br> - 목록 화면 UI 구현 |
| 23.06.13(화) | - 자이로 데이터를 나타내는 뷰 구현 </br> - 데이터 측정 화면 구현 |
| 23.06.14(수) | - 데이터 측정 기능 구현 </br> |
| 23.06.15(목) | - 코어데이터 모델 및 저장/삭제/읽기 기능 구현 </br> - 저장된 데이터를 재생하는 플레이어 구현 |
| 23.06.16(금) | - 셀의 Pagination 구현 </br> - 데이터 재생 상태를 제어하는 뷰 구현 |
| 23.06.17(토) | - JSON 데이터로 저장/삭제/읽기 기능 구현 </br> - 요구사항과 구현사항 검토 및 버그 수정 </br> |

</br>

# 🏗️ 프로젝트 구조
UIKit과 MVVM 패턴을 적용하였고, Combine을 사용하였습니다.

| UI | 아키텍처 | 반응형 프레임워크 |
| :---: | :---: | :---: |
| UIKit | MVVM | Combine |

다음과 같이 View는 ViewModel을 통해 Service와 상호작용을 하는 방향으로 구현하였습니다.

<img src="https://hackmd.io/_uploads/Hk6iNGjDn.png" width=700>

</br>

## 데이터베이스 구조
저장한 데이터는 코어데이터와 파일시스템에 저장됩니다.

<img src="https://hackmd.io/_uploads/H153JfjP3.png" width=500>

코어데이터에는 좌표 데이터가 저장되지 않고, 화면에 표시하기 위해 필요한 정보와 데이터를 식별하기 위한 UUID만 저장됩니다. 파일 시스템에는 모든 데이터가 저장됩니다.

</br>

## Fire Tree

<details>
    <summary><big>📂 펼치기 / 접기 </big></summary>

```
GyroData
├── Info.plist
│
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
│
├── Resources
│   ├── Assets.xcassets
│   └── Base.lproj
│
└── Sources
    ├── Database
    │   ├── CoreData.xcdatamodeld
    │   ├── GyroEntity+CoreDataClass.swift
    │   ├── CoreDataManager.swift
    │   ├── JSONCoder.swift
    │   └── GyroDataManager.swift
    ├── Utilitiy
    │   ├── AlertManager.swift
    │   ├── Array+subscript.swift
    │   ├── DateFormatter+dateToText.swift
    │   └── UITableViewCell+ReuseIdentifying.swift
    ├── Model
    │   ├── DataAccessObject.swift
    │   ├── DataTransferObject.swift
    │   ├── Coordinate.swift
    │   └── GyroData.swift
    ├── GyroList
    │   ├── GyroListCell.swift
    │   ├── GyroListViewController.swift
    │   └── GyroListViewModel.swift
    ├── RecordGyro
    │   ├── GraphView.swift
    │   ├── GyroRecorder.swift
    │   ├── RecordGyroViewController.swift
    │   └── RecordGyroViewModel.swift
    └── PlayGyro
        ├── PlayControlView.swift
        ├── GyroPlayer.swift
        ├── PlayGyroViewController.swift
        └── PlayGyroViewModel.swift
```

</details>

## Class Diagram
![](https://hackmd.io/_uploads/HkseiboPn.png)

</br>

<details>
    <summary><big>📂 계층 별 확대 펼치기 / 접기 </big></summary>

![](https://hackmd.io/_uploads/Sy8MsWiv3.png)
    
![](https://hackmd.io/_uploads/r19fsWjwn.png)
    
![](https://hackmd.io/_uploads/HJRzj-ow3.png)
    
![](https://hackmd.io/_uploads/rJx7o-jwh.png)

</details>

</br>

# 📜 구현 기능
## 목록 화면
|**10개 단위의 pagination** | **스와이프로 삭제** |
|:---: | :---: |
| <img src="https://hackmd.io/_uploads/SJ9-eesD3.gif" width=250> | <img src="https://hackmd.io/_uploads/B1pbgljDh.gif" width=250> |

- 코어데이터에서 데이터를 읽어옵니다. 읽어온 데이터에는 좌표 정보가 없습니다.
- 10개 단위로 pagination됩니다. 더이상 읽어올 데이터가 없을 경우 읽어오기를 시도하지 않습니다.
- 스와이프로 데이터를 삭제합니다. 데이터를 삭제하면 코어데이터와 파일매니저에서 모두 삭제됩니다.

## 측정 화면
| **측정 후 저장** | **60초 초과 시 자동 중지** | **측정 중 재측정** |
| :---: | :---: | :---: |
| <img src="https://hackmd.io/_uploads/rkXOeloPn.gif" width=250> | <img src="https://hackmd.io/_uploads/Hkw_egjP3.gif" width=250> | <img src="https://hackmd.io/_uploads/BkFOggoD3.gif" width=250> |

- Acc, Gyro 중 하나를 선택하여 측정합니다.
- 측정된 데이터가 없는 상태에서 저장을 시도하면 알림을 표시합니다.
- 데이터 저장 시 인디케이터가 표시되며, 저장에 성공하면 코어데이터와 파일시스템에 각각 저장됩니다.
- 저장에 실패하면 알림을 표시합니다.
- 측정 중 y축의 최대값 범위를 벗어나면 y축의 스케일이 재조정됩니다.
- 최대 60초간 600개의 데이터를 저장할 수 있으며, 60초가 넘을 경우 측정은 자동으로 중지됩니다.
- 측정 중 다시 측정 버튼을 누르면 측정하던 데이터는 삭제하고 새롭게 측정합니다.


## 다시보기 화면
| **View 모드** | **Play 모드** | **Play 모드** |
| :---: | :---: | :---: |
| <img src="https://hackmd.io/_uploads/BkeIMljv3.gif" width=250> | <img src="https://hackmd.io/_uploads/B1MDfgsP3.gif" width=250> | <img src="https://hackmd.io/_uploads/r1iy7xjD2.gif" width=250> |

- 셀을 클릭하면 View 모드로 다시보기 화면이 실행됩니다. 파일시스템에서 데이터를 불러오며, 불러온 데이터가 한 번에 모두 표시됩니다.
- 셀을 스와이프한 후 Play 버튼을 클릭하면 Play 모드로 다시보기 화면이 실행됩니다. Play 모드에서는 0.1초마다 데이터를 하나씩 읽어와서 화면에 그립니다.
- Play 모드에서는 데이터를 끝까지 재생하면 자동으로 중지됩니다.
- 중지 상태에서 다시 재생 버튼을 클릭하면 데이터의 처음부터 재생됩니다.

</br>

# 😢 아쉬운 점
## 에러 처리 미흡
에러 처리는 데이터 저장 시에만 구현되어 있으며, 저장 실패 시 알림을 표시하지만 시스템이 발생한 에러를 그대로 표시하기 때문에 사용자가 어떤 에러인지 정확히 알 수 없습니다.

## 테스트 부재
테스트 코드는 작성되어있지 않습니다.

</br>

# 📚 참고 링크
- [🍎 Combine](https://developer.apple.com/documentation/combine)
- [🍎 CoreMotion](https://developer.apple.com/documentation/coremotion)
- [🍎 FileManager](https://developer.apple.com/documentation/foundation/filemanager)
- [🍎 Core Graphics](https://developer.apple.com/documentation/coregraphics)
- [🍎 draw(_:)](https://developer.apple.com/documentation/uikit/uiview/1622529-draw)
- [🍎 setNeedsDisplay()](https://developer.apple.com/documentation/uikit/uiview/1622437-setneedsdisplay)
