# 팀 그라운드 룰

<p align="center">
<img width="200" src="https://user-images.githubusercontent.com/42936446/210076301-889d626d-9c63-4426-a2a9-bb5e04aa0344.jpg">
</p>

### Tak
- 측정된 자이로 데이터를 보여주는 테이블뷰의 UI 구현
- 자이로를 측정하는 내용의 그래프뷰 UI 구현

<p align="center">
<img width="200" alt="스크린샷 2022-12-30 오후 10 37 15" src="https://user-images.githubusercontent.com/42936446/210076027-fbf054f0-d933-4931-b6d1-9b40050fbeb2.png">
</p>

### SooJi
- 코어데이터를 통한 자이로 측정 데이터 불러오기 로직 구현
- 그래프뷰에 보여질 자이로 데이터를 측정하는 로직 구현

## 커밋 컨벤션
- feat : 새로운 기능 추가
- fix : 버그 수정
- docs : 문서 수정
- style : 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
- refactor : 코드 리팩토링
- test : 테스트 코드, 리팩토링 테스트 코드 추가
- chore : 빌드 업무 수정, 패키지 매니저 수정

## 테크
- Observer 패턴을 활용하여 바인딩하는 MVVM 디자인 패턴 적용
- Data Layer, Domain Layer, Presenter Layer로 구분하여 MVVM 적용
- ViewController가 ViewModel에게 이벤트를 전달하고 데이터를 내려 받는 양방향 데이터 바인딩 적용

## 기능
- 자이로 데이터 측정 구현
<img width="300" height="300" alt="스크린샷 2022-12-30 오후 10 37 15" src="https://user-images.githubusercontent.com/42936446/210075620-a973cf7d-caf5-4867-92f2-4b025de79c55.gif">

