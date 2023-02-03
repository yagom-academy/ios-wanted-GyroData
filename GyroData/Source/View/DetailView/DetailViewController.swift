//
//  DetailViewController.swift
//  GyroData
//
//  Created by Aejong on 2023/02/03.
//

import UIKit

enum PageType: String {
    case play = "Play"
    case view = "View"
}

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let dateLabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let pageTypeLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: nil)
        
        return label
    }()
    
    private var graphView = UIView()
    
    private let playButton = {
        let button = UIButton()
        
        return button
    }()
    
    private let timerLabel = {
        let label = UILabel()
        
        return label
    }()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        // Do any additional setup after loading the view.
    }
    
    private func addSubViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(pageTypeLabel)
        stackView.addArrangedSubview(graphView)
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(timerLabel)
        setGraph()
    }
    
    private func setGraph() {
        let padding: CGFloat = 100
        
        let frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width - padding,
            height: self.view.frame.height - padding
        )
        let view = LineGraphView( // 그래프 뷰
            frame: frame,
            values: [20, 10, 30, 20, 50, 100, 10, 10]
        )

        view.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        self.view.addSubview(view)
        graphView = view
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
