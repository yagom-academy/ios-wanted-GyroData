//
//  MeasurementView.swift
//  GyroData
//
//  Created by 우롱차 on 2022/12/27.
//

import UIKit

final class MeasurementViewController: UIViewController {
    
    private enum Constant {
        static let segmentLeftText = "Acc"
        static let segmentRightText = "Gyro"
        static let measurementButtonText = "측정"
        static let stopButtonText = "정지"
        static let saveButtonText = "저장"
        static let cancleButtonText = "취소"
        
        static let graphViewBorderColor = UIColor.gray
        
        static let measurementButtonColor = UIColor.green
        static let stopButtonColor = UIColor.yellow
        static let saveButtonColor = UIColor.blue
        static let cancleButtonColor = UIColor.red
        static let measurementButtonTextColor = UIColor.black
        static let measurmentButtonTextColor = UIColor.black
        static let stopButtonTextColor = UIColor.black
        static let saveButtonTextColor = UIColor.black
        static let cancleButtonTextColor = UIColor.black
        static let buttonSize: CGFloat = 80
        static let activityIndicatorSize: CGFloat = 100
        static let offset: CGFloat = 30
        static let indicatorSize: CGFloat = 100
    }
    
    weak var coordinator: MotionListCoordinatorInterface?
    private let viewModel: MeasermentViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bind()
    }
    
    init(viewModel: MeasermentViewModel, coordinator: MotionListCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.currentMotion.observe(on: self) { [weak self] value in
            self?.drawGraph(data: value)
        }
        viewModel.status.observe(on: self) { [weak self] value in
            switch value {
            case .ready:
                self?.measurementButton.isHidden = false
                self?.stopButton.isHidden = true
                self?.saveButton.isHidden = true
                self?.cancleButton.isEnabled = false
                self?.segmentControl.isEnabled = true
            case .start:
                self?.measurementButton.isHidden = true
                self?.stopButton.isHidden = false
                self?.saveButton.isHidden = true
                self?.cancleButton.isEnabled = true
                self?.segmentControl.isEnabled = false
            case .stop:
                self?.measurementButton.isHidden = true
                self?.stopButton.isHidden = true
                self?.saveButton.isHidden = false
                self?.cancleButton.isEnabled = true
                self?.segmentControl.isEnabled = false
            case .save:
                self?.indicatorView.startAnimating()
            case .done:
                self?.indicatorView.stopAnimating()
                self?.coordinator?.popViewController()
            }
        }
        
        viewModel.errorMessage.observe(on: self) { [weak self] value in
            if let message = value {
                self?.indicatorView.stopAnimating()
                self?.showErrorAlert(message: message)
            }
        }
    }
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.frame = CGRect(
            x: 0, y: 0, width: Constant.activityIndicatorSize, height: Constant.activityIndicatorSize
        )
        view.frame = CGRect(x: 0, y: 0, width: Constant.indicatorSize, height: Constant.indicatorSize)
        view.center = self.view.center
        view.color = UIColor.gray
        view.style = UIActivityIndicatorView.Style.large
        view.stopAnimating()
        return view
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Constant.segmentLeftText, Constant.segmentRightText])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var measurementButton: UIButton = {
        let button = RoundButton(backgroundColor: Constant.measurementButtonColor)
        button.setTitle(Constant.measurementButtonText, for: .normal)
        button.setTitleColor(Constant.measurmentButtonTextColor, for: .normal)
        button.addTarget(self, action: #selector(startMeasurement(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = RoundButton(backgroundColor: Constant.stopButtonColor)
        button.setTitle(Constant.stopButtonText, for: .normal)
        button.setTitleColor(Constant.stopButtonTextColor, for: .normal)
        button.addTarget(self, action: #selector(stopMeasurement(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = RoundButton(backgroundColor: Constant.saveButtonColor)
        button.setTitle(Constant.saveButtonText, for: .normal)
        button.setTitleColor(Constant.saveButtonTextColor, for: .normal)
        button.addTarget(self, action: #selector(saveMeasurement(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var cancleButton: UIButton = {
        let button = RoundButton(backgroundColor: Constant.cancleButtonColor)
        button.setTitle(Constant.cancleButtonText, for: .normal)
        button.setTitleColor(Constant.cancleButtonTextColor, for: .normal)
        button.addTarget(self, action: #selector(cancleMeasurement(_:)), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK - func
    func drawGraph(data: MotionValue?) {
        DispatchQueue.main.async {
            self.graphView.drawGraph(data: data)
        }
    }
    
    @objc func startMeasurement(_ sender: UIButton) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.measerStart(type: .accelerometer)
        case 1:
            viewModel.measerStart(type: .gyro)
        default:
            return
        }
    }
    
    @objc func stopMeasurement(_ sender: UIButton) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.measerStop(type: .accelerometer)
        case 1:
            viewModel.measerStop(type: .gyro)
        default:
            return
        }
    }
    
    @objc func saveMeasurement(_ sender: UIButton) {
        do {
            switch segmentControl.selectedSegmentIndex {
            case 0:
                try viewModel.measerSave(type: .accelerometer)
            case 1:
                try viewModel.measerSave(type: .gyro)
            default:
                return
            }
        } catch {
            showErrorAlert(message: error.localizedDescription)
        }
    }
    
    @objc func cancleMeasurement(_ sender: UIButton) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.measerCancle(type: .accelerometer)
        case 1:
            viewModel.measerCancle(type: .gyro)
        default:
            return
        }
        graphView.clean()
    }
}

extension MeasurementViewController {
    
    private func setUpView() {
        view.addSubview(segmentControl)
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.offset),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.offset)
        ])
        
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.offset),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            graphView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Constant.offset),
            graphView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        view.addSubview(cancleButton)
        NSLayoutConstraint.activate([
            cancleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.offset),
            cancleButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.offset),
            cancleButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            cancleButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize)
        ])
        
        view.addSubview(measurementButton)
        NSLayoutConstraint.activate([
            measurementButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancleButton.trailingAnchor),
            measurementButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.offset),
            measurementButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            measurementButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            measurementButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize)
        ])
        
        view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancleButton.trailingAnchor),
            stopButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.offset),
            stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            stopButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            stopButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize)
        ])
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(greaterThanOrEqualTo: cancleButton.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: Constant.offset),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            saveButton.widthAnchor.constraint(equalToConstant: Constant.buttonSize),
            saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonSize)
        ])
        
        view.addSubview(indicatorView)
    }
}
