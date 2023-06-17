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
        
        return stackView
    }()
    
    private let segmentedControl = UISegmentedControl(items: ["Acc", "Gyro"])
    private let graphView: GraphView
    private let loadingIndicatorView = UIActivityIndicatorView(style: .large)
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
        setupSegmentedControl()
        setupLoadingIndicatorView()
        setupNavigationItems()
        setupRecordButton()
        setupStopButton()
        bind()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        view.addSubview(loadingIndicatorView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -32),
            
            segmentedControl.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            graphView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            graphView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
            
            loadingIndicatorView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.4),
            loadingIndicatorView.heightAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupSegmentedControl() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentTintColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.borderWidth = 2.0
    }
    
    private func setupLoadingIndicatorView() {
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
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
                                             style: .plain,
                                             target: self,
                                             action: #selector(save))
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title2)], for: .normal)
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title2)], for: .disabled)
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func stopAndDismiss() {
        viewModel.stopRecord()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func save() {
        if viewModel.isNoData {
            let alert = AlertManager().createNoDataAlert()
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        loadingIndicatorView.startAnimating()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            do {
                try self?.viewModel.save()
                
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            } catch {
                let alert = AlertManager().createErrorAlert(error: error)
                
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                    self?.loadingIndicatorView.stopAnimating()
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }
    }
    
    private func setupGraphView() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupRecordButton() {
        let title = "측정"
        recordButton.setTitle(title, for: .normal)
        recordButton.setTitleColor(.systemBlue, for: .normal)
        recordButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        
        recordButton.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
    }
    
    private func setupStopButton() {
        let title = "정지"
        stopButton.setTitle(title, for: .normal)
        stopButton.setTitleColor(.systemBlue, for: .normal)
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
