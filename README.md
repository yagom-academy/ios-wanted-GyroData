# Gyro Data 🏃🏻
> <프로젝트 기간>

2022-12-26 ~ 2022-12-30

## 소개 📑
> Gyro & Accelerometer 센서를 이용하여 가속도와 움직임을 감지하는 `Application` 입니다.
 
<br>

## 팀원 🤼‍♂️
> 안녕하세요 ! Gyro Data 프로젝트를 함께하는 **`bonf`** 와 **`hyeon2`**  입니다 ! 🙋🏻‍♂️ 🙋🏻‍♀️
> 
|bonf| seohyeon2|
|:-------:|:--------:|
| <img src="https://i.imgur.com/yGJljLR.jpg" width="350" height="350"/> |  <img src="https://avatars.githubusercontent.com/u/50102522?v=4?s=100" width="350" height="350"/>    |
|[@apwierk2451]("https://github.com/seohyeon2")|[@seohyeon2]("https://github.com/seohyeon2")| 


## 구현 화면 📱

|MainView| MeasureView|ReplayView(play) |
|:-------:|:--------:|:--------:|
|<img src="https://i.imgur.com/aTXW9zE.png" width="200" height="400"/> |<img src="https://i.imgur.com/8z11Pgr.png" width="200" height="400"/>| <img src="https://i.imgur.com/74Nrdkh.png" width="200" height="400"/>|

|ReplayView(view)| SwipeAction|FileManager|
|:-------:|:--------:|:--------:|
|<img src="https://i.imgur.com/O4uWZqg.png" width="200" height="400"/> |<img src="https://i.imgur.com/XfDrX4L.png" width="200" height="400"/>| <img src="https://i.imgur.com/SmDU1qy.png" width="200" height="400"/>|


## 구현 내용 🧑‍💻

#### MainView 
- TableView 구성
- 측정 시간, 측정 종류(Gyro, Accelerometer), 측정 날짜를 나타내는 cell로 구성되어있다. 
- 각 셀은 swipe를 이용하여 play, delete가 가능하다.
- DiffableDataSource를 마지막 데이터까지 나타나면 10개의 데이터를 가져온다.

#### MeasureView
- SegmentControl을 이용하여 측정 종류를 고른 후 측정 버튼을 누르면 측정이 시작된다.
- 측정이 시작되면 현재 스마트폰의 측정 값이 그래프와 수치로 나타난다.
- 정지 버튼 클릭 시 측정이 정지된다.
- 정지된 상태에서 저장 버튼 클릭 시 CoreManager에 저장되고 FileManager를 통해 Document에 파일이 저장된다.

#### ReplayView
- 플레이 버튼 클릭 시 저장되어있던 데이터를 이용하여 차트에 측정 값 표시
- 정지 버튼 클릭 시 차트 정지
<br>

## 핵심 경험 💡
- [x] CoreData
- [x] CoreMotion
- [x] FileManager
- [x] UIBeziurPath
- [x] CAShapeLayer
- [x] DiffableDataSource

<br>

## 트러블 슈팅 🧐
### 1. frame, bounds 크기 설정 타이밍
- ReplayView의 ChartView의 frame 크기를 이용하여 xOffset을 쓰려고 했지만, frame의 width, height 모두 0값으로 나오는 문제가 발생했습니다. frame의 크기가 결정되기 전이라서 발생한 문제인 것 같아서 viewWillAppear에서 작성하며 임시적으로 수정하였지만, 다른 방법이 떠오르지않아 아직 완전한 해결을 하지 못했습니다.
<br>

### 2. CABasicAnimation 차트 문제
- 처음 차트 그리는 것을 CABasicAnimation을 이용하여 차트를 그리는 방식으로 구현했습니다. 그래프 애니메이션이 끝나는 시간은 동일하나, x, y, z각 그래프의 선 길이가 다르기 때문에 시점이 맞지 않는 문제가 발생했습니다. 그래서 플레이 버튼 클릭 시 타이머를 발생해 0.1초마다 다음 좌표로 그림을 그리는 방식으로 수정하여 해결하였습니다.
