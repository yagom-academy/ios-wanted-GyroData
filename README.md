
# 프로젝트 진행
| [Jeremy - 박제민](https://github.com/yjjem) |
| :--------: |
| <a href="https://github.com/yjjem"><img width="180px" src="https://i.imgur.com/RbVTB47.jpg"></a>     |

# 실행 화면

| 단일 데이터 측정 화면 |
| -------- |
| <img src="https://i.imgur.com/bXK8pEx.gif" height="500px"/> |

# 프로젝트 구조 ( Clean Architecture + MVVM )
![](https://i.imgur.com/7w40P4l.png)

## 구조 설명 

### Presentation, Domain, Data
- Presentation: UI로직을 담당하
- Domain
    - UseCase: ViewModel의 요청을 수행
    - Entity: 데이터
- Data
    - DB, Netwrok, Device 데이터의 본체
    - Repository: Data객체에 대한 사용 인터페이스 제공

### MotionLogList
- ViewModel이 CleanArchitecture흐름을 통해 CoreData에 저장된 MotionData들을 가져오게하여 View에 나타내는 것이 목표

### MotionMeasurement
- ViewModel이 CleanArchitecture흐름을 통해 CoreMotion의 데이터를 받아와 GraphView를 업데이트하는 것이 목표



## 성능 개선

| 성능 개선 전 ( Hitch, CPU 과부화, latency ) |
| -------- |
| ![](https://i.imgur.com/TZ4cNRJ.jpg)     |
| ![](https://i.imgur.com/FoYrF8i.png) |

| 성능 개선 후 ( Hitch 줄어듦, backboardd 사용량 줄어듦 ) |
| -------- |
| ![](https://i.imgur.com/PskuHEc.jpg) |
| ![](https://i.imgur.com/optcb1o.png) |
