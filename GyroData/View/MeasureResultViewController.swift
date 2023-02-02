//
//  MeasureResultViewController.swift
//  GyroData
//
//  Created by stone, LJ on 2023/02/02.
//

import UIKit

class MeasureResultViewController: UIViewController {
    var data: [Coordinate] = []
    
    var graphView: GraphView = {
        let view = GraphView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: imageConfig), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        button.setImage(UIImage(systemName: "stop.fill", withConfiguration: imageConfig), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00.0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
    }
    
    func configureLayout() {
        view.addSubview(dateLabel)
        view.addSubview(pageLabel)
        view.addSubview(graphView)
        view.addSubview(playButton)
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            pageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            pageLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            
            graphView.topAnchor.constraint(equalTo: pageLabel.bottomAnchor, constant: 20),
            graphView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            playButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 30),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            timeLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor)
        ])
    }
    
    func configureData(date: Date?, page: String?, data: [Coordinate]?) {
        dateLabel.text = "\(date!)"
        pageLabel.text = page
        guard let data else { return }
        self.data = data
    }
}
