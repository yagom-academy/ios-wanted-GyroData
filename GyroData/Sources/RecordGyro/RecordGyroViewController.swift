//
//  RecordGyroViewController.swift
//  GyroData
//
//  Created by kokkilE on 2023/06/12.
//

import UIKit
import Combine

final class RecordGyroViewController: UIViewController {
    private lazy var stackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, graphView, recordButton, stopButton])
        
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        return stackView
    }()
    
    private let segmentedControl = GyroSegmentedControl(items: ["Acc", "Gyro"])
    private let graphView: GraphView
    private let recordButton = UIButton()
    private let stopButton = UIButton()
    
    private let viewModel: RecordGyroViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        viewModel = RecordGyroViewModel()
        graphView = GraphView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupNavigationItems()
        setupSegmentedControl()
        setupRecordButton()
        setupStopButton()
        bind()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(segmentedControl)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -32),
            
            segmentedControl.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
    
    private func setupNavigationItems() {
        let title = "측정하기"
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        navigationItem.titleView = titleLabel
        
        let systemImageName = "chevron.backward"
        let leftButtonImage = UIImage(systemName: systemImageName)
        let leftBarButton = UIBarButtonItem(image: leftButtonImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(stopAndDismiss))
        leftBarButton.tintColor = .label

        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButtonTitle = "저장"
        let rightBarButton = UIBarButtonItem(title: rightBarButtonTitle,
                                             image: nil,
                                             target: self,
                                             action: #selector(save))
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title2)], for: .normal)
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title2)], for: .disabled)
        rightBarButton.isEnabled = false
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func stopAndDismiss() {
        viewModel.stopRecord()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func save() {
        viewModel.save()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupGraphView() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupRecordButton() {
        let title = "측정"
        recordButton.setTitle(title, for: .normal)
        recordButton.setTitleColor(.tintColor, for: .normal)
        recordButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        
        recordButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
    }
    
    private func setupStopButton() {
        let title = "정지"
        stopButton.setTitle(title, for: .normal)
        stopButton.setTitleColor(.tintColor, for: .normal)
        stopButton.setTitleColor(.systemGray, for: .disabled)
        stopButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        stopButton.isEnabled = false
        
        stopButton.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
    }
    
    @objc private func startRecord() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        viewModel.startRecord(dataTypeRawValue: selectedIndex)
    }
    
    @objc private func stopRecord() {
        viewModel.stopRecord()
    }
    
    private func bind() {
        viewModel.gyroRecorderStatusPublisher()
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] isUpdating in
                self?.navigationItem.rightBarButtonItem?.isEnabled = !isUpdating
                self?.segmentedControl.isEnabled = !isUpdating
                self?.stopButton.isEnabled = isUpdating
            }
            .store(in: &subscriptions)
        
        viewModel.gyroDataPublisher()
            .sink { [weak self] gyroData in
                self?.graphView.configureUI(gyroData: gyroData)
            }
            .store(in: &subscriptions)
    }
}
