//
//  MeasureResultViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import UIKit

class MeasureResultViewController: UIViewController {
    var graphView = GraphView()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜" //함수로 주입받기
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.text = "페이지" //함수로 주입받기
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간" //함수로 주입받기
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        // Do any additional setup after loading the view.
    }
    
    func configureLayout() {
        view.addSubview(dateLabel)
        view.addSubview(pageLabel)
        view.addSubview(graphView)
//        view.addSubview(playButton)
//        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            pageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            pageLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            graphView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 20),
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor)

//
//            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
//            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            timeLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
//            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
            
        ])
    }
    

}
