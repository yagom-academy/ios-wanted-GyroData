# GyroData
<br>

|삭제|이동|측정 후 저장|Play|
|------|---|---|---|
|![](https://user-images.githubusercontent.com/73588175/192685523-a7e34db4-37c4-4855-aaad-b76d700d8775.gif)|![](https://user-images.githubusercontent.com/73588175/192685528-2d588eae-fbd0-4991-9bf3-706aa9e0c482.gif)|![](https://user-images.githubusercontent.com/73588175/192685533-785c4dc0-a6f7-430a-a4cf-6ab39b5ae3f2.gif)|![](https://user-images.githubusercontent.com/73588175/192685543-7686e6a6-8122-4854-8584-b7cfa10d6a3f.gif)|
<br>

## Index
- [팀원](#팀원)
- [구조 및 기능](#구조-및-기능)
- [고민한 내용](#고민한-내용)
- [회고](#회고)
<br>
<br>

## 팀원
![](https://user-images.githubusercontent.com/73588175/192675239-992d47db-c313-4e3d-8b8f-992c122a2d3e.png)
<br>
<br>

## 구조 및 기능
![](https://user-images.githubusercontent.com/73588175/192682846-22fec575-0d7d-4beb-9bd9-29a194a9fcda.png)
<br>
<br>

### Extension
- Date+Extension  
    Date type을 String type으로 변환
- UIKit+Extension
    사용자에게 보여질 메시지를 입력받아 알럿을 띄움
<br>

### Utils
- FimeManagerService 
    motion data를 JSON형태로 파일에 저장/읽기/삭제 
- CoreMotionService
    장치의 움직임(Acc, Gro) 데이터 획득
- CoreDataStack
    CoreData를 사용하기 위한 환경설정
- CoreDataService
    motion data를 저장/읽기/삭제
<br>

### Models
- MotionData ⊃ MotionDataItems
    motion data 모델
- CDMotionData ⊃ CDMotionDataItems
    CoreData로 사용하기 위한 모델 
<br>

### Views
- ListView
    - ListViewController
        CoreData의 목록을 표현
    - ListCell
- MeasureView
    - MeasureViewController
        기기의 움직임을 측정 후 저장
- ReplayView
    - ReplayViewController
        저장된 MotionData를 그래프로 표현
<br>
