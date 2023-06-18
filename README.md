# README
# GyroData
> 6축 데이터(acc 3축 + gyro 3축)를 실시간으로 측정하는 앱
> 
> 프로젝트 기간: 2023.06.12 - 2023.06.18
> 

## 개발자

| 리지 |
|  :--------: | 
|<Img src ="https://user-images.githubusercontent.com/114971172/221088543-6f6a8d09-7081-4e61-a54a-77849a102af8.png" width="200" height="200"/>
|[Github Profile](https://github.com/yijiye)


## 목차
1. [실행 화면](#실행-화면)
2. [앱 기능](#앱-기능)
3. [적용 기술](#적용-기술)
4. [추가구현](#추가구현)


<br/>

# 실행 화면



<br/>

# 앱 기능

- 측정 버튼을 눌러 Acc, Gyro 타입의 데이터를 선택하여 측정
- Swipe하여 delete 또는 play
- play 버튼 클릭시 저장된 데이터 실시간으로 화면에 그리기 
- 저장된 List 클릭시 view 모드로 저장된 데이터 띄우기


</br>

|                            메인 화면                             |                               삭제                               |                            측정 화면                             |                          play 모드|                              view 모드                              |
|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:----------------------------------------------------------------:|
| <img src="https://hackmd.io/_uploads/S1FPiZ2P2.gif" width="300"> | <img src="https://hackmd.io/_uploads/HyfYsbnvh.gif" width="300"> | <img src="https://hackmd.io/_uploads/ryioj-3v3.gif" width="300"> | <img src="https://hackmd.io/_uploads/Hk2hsZhw2.gif" width="300"> | <img src="https://hackmd.io/_uploads/HJ3Rob2v2.gif" width="300"> |


<br/>



# 적용 기술

|  UI   | Local DB  | Reactive | Architecture | 
|:-----:|:--------:|:--------:|:------------:|
| UIKit | CoreData, FileManager | Combine  |     MVVM     | 

## 세부 내용

#### 화면구현
- UIKit을 사용하여 코드베이스로 UI를 구성하였습니다.
- 총 3개의 화면으로 구성되어 있습니다.
   - GyroDataList 화면
   - Measurement 화면
   - Detail (view 모드, play 모드) 화면
- `GyroDataList` 화면은 `UITableView`를 활용하였습니다.
- 데이터 구성은 `DiffableDataSource`, `NSDiffableDataSourceSnapshot`를 사용하였습니다.
- `Measurement` 화면은 segmentedControl, 그래프 view, 버튼 2개로 구현되어 있어 값을 측정할 수 있습니다.
- `Detail` 화면은 2가지 모드가 있어 `cell`을 선택하면 `view`모드가 선택되어 저장된 값을 화면에 보여주고, `Swipe action`을 통해 `play` 버튼을 선택하면 `play` 모드가 선택되어 실시간으로 그래프를 그려줍니다.

#### DataBase
- 측정한 값은 CoreData와 FileManager로 저장되고 CoreData에는 날짜, 제목, 측정시간이 저장되고 FileManager에는 측정한 값을 JSON 파일로 encoding하여 저장됩니다.
- List 화면에 띄우는 정보는 CoreData에서 가져옵니다.
- 그래프 화면에 띄우는 정보는 FileManager에 저장된 JSON 파일을 Decoding하여 가져옵니다.

#### Reactive, Architecture
- ViewController의 역할을 분리하고자 MVVM 패턴을 사용하였습니다.
- View - ViewModel간 바인딩시 Apple에서 제공하는 Combine 프레임워크를 사용하였습니다.
    

<br/>

# 추가구현

- 디자인 패턴중 `Builder` 패턴을 활용하여 `AlertBuilder`를 구현하였습니다.

```swift
private func showAlert(_ title: String, _ message: String) {
    let okSign = "확인"
    AlertBuilder(viewController: self)
        .withTitle(title)
        .andMessage(message)
        .preferredStyle(.alert)
        .onSuccessAction(title: okSign) { _ in }
        .showAlert()
}
```

 <br/>
 



