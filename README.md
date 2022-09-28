# ios-wanted-GyroData

</br>

## 팀원  소개

|Eddy(권준상)|James(엄철찬)|Beeem(김수빈)|
|:---:|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/31722496/192504266-ff50f0da-68f1-488d-82a5-765cc5a249be.png" width="200" height="200"/>|<img src="https://user-images.githubusercontent.com/31722496/192505455-1ce3728a-1efe-4574-8709-cd2f0afc39ab.png" width="200" height="200"/>|<img src="https://user-images.githubusercontent.com/31722496/192567901-5f1ede08-e89e-4adf-b987-2af47ec2d1a3.png" width="200" height="200"/>|
|CoreMotion 담당|GraphView 담당|CoreData 담당|
|아키텍쳐 및 다크모드|타이머 로직 담당|FileManager 담당|
|[Github](https://github.com/JunsangKwon)|[Github](https://github.com/ecc414)|[Github](https://github.com/skyqnaqna)|

</br>

## 🎁 프로젝트 구조


### **MVC 패턴**

<img width="880" alt="Screen Shot 2022-09-28 at 13 14 35" src="https://user-images.githubusercontent.com/31722496/192686217-9fd5a8c0-e7de-4cc1-b600-7edf42d71563.png">

- ViewController가 방대해지는 것을 방지하기 위해 View와 분리했습니다.

</br>

## 📁 폴더 구조

<img width="230" alt="스크린샷 2022-09-05 오후 4 22 01" src="https://user-images.githubusercontent.com/31722496/192508877-bbfa5d76-d483-4433-b5bb-3bc0f19a6ff5.png">

### Application 
- AppDelegate, SceneDelegate, Info.plist 등 

### Source 
- **Model**: 앱 내에서 사용되는 데이터 관련 모음
- **Extensions**: Extension 모음

### Feature
- **GraphView**: Graph View 관련 모음
- **CoreData**: Core Data Model 관련 모음
- **MotionDataList**: 첫 번째 화면 관련 모음
- **MeasureData**: 두 번째 화면 관련 모음
- **GraphDetail**: 세 번째 화면 관련 모음

</br>

## 📱 구현 화면

### 첫 번째 화면

</br>

<img width="800" alt="Screen Shot 2022-09-28 at 13 09 17" src="https://user-images.githubusercontent.com/31722496/192685721-502b4086-10ef-412a-9847-912d564e8be4.png">

</br>

### 두 번째 화면

<img width="793" alt="Screen Shot 2022-09-28 at 13 10 23" src="https://user-images.githubusercontent.com/31722496/192685785-1cfbb7ab-4a2a-4ed7-9520-9ce898d49a4c.png">

</br>

### 세 번째 화면

<img width="1154" alt="Screen Shot 2022-09-28 at 13 11 21" src="https://user-images.githubusercontent.com/31722496/192685875-48d14671-db3f-41e3-a726-45397c3002f8.png">

</br>

## 🛠 기능 구현 방식

**AutoLayout**
- StoryBoard를 제거하고 코드로 View를 구현하였습니다.

**Core Motion**
- CMMotionManager를 이용해서 acc값과 gyro 값을 가져왔습니다.

**Graph**
- UIBezierPath를 이용해서 그래프를 그렸습니다.
- CoreMotion으로 측정한 값을 리스트에 담아서 0.1초마다 표시하도록 구현했습니다.
- 측정된 값이 지정한 최대치에 도달하면 그래프의 크기를 1.2배 축소시킵니다.

**Core Data & FileManager**
- 측정된 데이터를 CoreData와 FileManager를 이용해서 저장했습니다.
- 데이터를 JSON 파일로 변환했습니다.

**Dark Mode**
- 다크 모드를 대응하였습니다.

</br>

## 📼 실행 영상

https://user-images.githubusercontent.com/31722496/192690852-8c8455a4-48db-424a-b47f-2fbe3f4cb23f.mov
