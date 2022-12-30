## Gyro-Data

**작업기간: 2022/12/26 ~ 2022/12/30**

**어플리케이션 설명:** 사용자 기기를 통해 accelerometer와 gyro 데이터를 측정하고, 그 결과값을 저장하고 다시 볼 수 있는 어플리케이션입니다.

**작동화면**

| <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221230180424.gif" alt="play+view+measure" style="zoom:50%;" /> | <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221230180353.gif" alt="fileRemove"  /> | <img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221230180330.gif" alt="fileOpen" style="zoom:50%;" /> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                          앱의 동작                           |                          파일 삭제                           |                          파일 열기                           |



## 적용 아키텍쳐: 클린 아키텍쳐

<img src="https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221230182257.png" alt="image-20221230182257869" style="zoom:50%;" />

이번 프로젝트에서는 클린 아키텍쳐를 적용해보았습니다.

클린아키텍쳐는 앱을 각 Layer로 나누어 내부에 있는 Layer는 바깥 Layer에 종속성을 가지지 않도록 하는것이 핵심적인 아키텍쳐입니다.

Domain Layer의 UseCase에서는 비즈니스 로직을 정의하였고

Data Layer의 Storage의 Interface에 해당하는 protocol을 Domain Layer에 정의함으로써

Domain Layer에는 외부 종속성이 걸리지 않도록 하였습니다. (Dependency Inversion 방지)

Data Layer에서는 DTO, CoreData Entity의 정의와 data fetching 로직들을 담았으며

Presentation Layer에서는 View와 ViewModel을 분리하여 ViewController의 부담을 줄여주었습니다.





### 앱 구조 도식화 (UML)

https://www.figma.com/file/1vyeSsmY86fHYzlomfCf3D/GyroData-%EA%B5%AC%EC%A1%B0?node-id=1%3A127&t=3iRrJVWRskO48ASL-1



## 팀원

**윤영서 (@aCafela-coffee)**

<img src = "https://user-images.githubusercontent.com/67148595/210053745-af09f692-e613-4923-92fe-5e57639a2035.png" width="40%" height="height 40%">

**천수현 (@Neph3779)**

<img src = "https://raw.githubusercontent.com/Neph3779/Blog-Image/forUpload/img/20221230163657.png" width="40%" height="height 40%">


## 작업 분할 내역

**GraphView**

- 페어프로그래밍으로 제작



**천수현 (Neph)**

- MotionDataList 화면 구현  (첫 번째 페이지) 
- MotionReplay 화면 구현 (세 번째 페이지)
- 앱의 Data Layer 제작 (Storage, CoreDataModel)
- 앱의 Domain Layer 제작 (UseCase)



**윤영서 (aCafela-coffee)**

- MotionRecording 화면 구현 (두 번째 페이지)
- CMMotionManager를 통해 Accelerometer, Gyro 데이터를 받아오는 로직 제작
- 앱의 Domain Layer 제작 (Entity)



