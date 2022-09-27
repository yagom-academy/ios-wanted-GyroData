# ios-wanted-GyroData
#GyroData.app
- **GyroData**
    - CommonUIModule.swift ( 공통 기능 선언 )
    - GyroExample ( CoreData Model )
    - **Model**
        - DataManager ( CoreData를 활용 데이터 관리 )
        - MotionManager ( CoreMotion을 이용한 센서 측정 )
    - **View**
        - GraphViewMaker ( 그래프를 그리고 선을 표현 )
    - **Controller**
        - ViewController ( 센서 기록 목록을 보여주는 리스트 뷰 )
        - MeasurementViewController ( 센서 측정을 담당하는 뷰 )
        - ReplayViewController ( 측정된 기록 Replay 뷰 )
        - **Cell**
            - TableViewCell ( ViewController에 사용되는 커스텀 테이블뷰 셀 )

## 각 팀원의 기여 파트

<p>
    <img width="170" height="220" src="https://user-images.githubusercontent.com/33388081/192535202-04ea588c-6557-4f7c-8f8f-3e6f06733049.jpeg">
    <img width="170" height="220" src="https://user-images.githubusercontent.com/98341623/192535980-095ead28-471c-4fa2-b5b8-ea65137c4d78.jpeg">
    <img width="170" height="220" src="">
</p>

- 강민교(Mango)
    - MeasurementViewController UI 코드 구현
    - 센서 측정 기능 구현
- 박현중(Tom)
    - ViewController UI 코드 구현
    - Core Data 기능 구현
- 유영훈(Keurong)
    - ReplayViewController의 UI 코드 구현
    - 그래프 차트를 표현하는 기능 구현

## CoreMotion을 사용한 센서값 측정 기능

- MotionManager.swift
    - 센서 측정 기능
    - 모듈화
        - CoreMotion을 사용하여 센서값을 측정하는기능을 모듈화.
        데이터 측정시 delegate패턴을 이용해 값을 전달.

## Core Data 기능구현

- GryoExample
- DataManager.swift
    
    CREATE(생성) mainContext() context를 저장하는 saveCntext()
    READ(읽기) - fetchSave()
    UPDATE(저장,업데이트) addNewSave()
    DELETE(삭제) - deleteRun()
    

## GraphView 구현 및 애니메이션 구현

- GraphViewMaker.swift
    - 그래프 차트뷰 만들기
    - 그래프 차트 선 표현
        - CAShapeLayer, UIBezierPath를 이용한 그래프 차트, 선 표현
        여러 뷰에서 활용하는 차트이기때문에 별도로 모듈화.
        - .play(), .stop(), .draw(), reset() 등의 함수를 통해 그래프 차트의 표현을 제어합니다.
    - 차트 스케일링
        - 기존방법 에서 수정된. multiplier 변수를 활용한 값 비율 조정으로 스케일링을 구현함.
            
            ```swift
            baseHeight = 그래프의 기준 영점
            maxOffset = 현재 측정된 좌표중 최대값
            
            x좌표가 최대값을 넘긴경우 ( baseHeight / maxOffset ) - 0.05 의 계산식을 가지는
            multiplier값을 선 표현시 데이터 곱하여 보여줍니다.
            결과적으로 값이 최대값을 넘어도 전체적으로 multiplier 변수에 영향을받아 비율이 조정됨.
            ```
