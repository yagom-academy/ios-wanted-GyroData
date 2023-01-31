//
//  ViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit

final class TransitionListViewController: UIViewController {

    // MARK: - Property
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let cellReuseIdentifier = "CustomCell"
    private var transitionMetaDatas: [TransitionMetaData] = []
    private var isPaginating = false
    private var calledBringPageCount = 0
    private var cellCount = 10

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        for count in 0...25 {
            transitionMetaDatas.append(
                TransitionMetaData(saveDate: "2022/09/10 15:11:45",
                                   sensorType: .Accelerometer,
                                   recordTime: Double(count),
                                   jsonName: "asdf")
            )
        }
    }
}

// MARK: - Method
private extension TransitionListViewController {
    // Error타입 만들어주기
    func bringAdditionalTransitionMetaData(completion: @escaping (Int) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            completion(10)
        }
    }
}

// MARK: - UITableViewDataSource
extension TransitionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CustomTableViewCell ?? CustomTableViewCell()
        customCell.configureCell(data: transitionMetaDatas[indexPath.row])
        return customCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/6
    }
}

// MARK: - UITableViewDelegate
extension TransitionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            print("play 클릭")
            completionHandler(false)
        }
        playAction.backgroundColor = .systemGreen

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            print("delete 클릭")
//            guard let data = self?.transitionMetaDatas[indexPath.row] else { return }
            self?.transitionMetaDatas.remove(at: indexPath.row)
//            PersistentContainerManager.shared.deleteTransitionMetaData(data: data)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
}

// MARK: - UIScrollViewDelegate
extension TransitionListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > tableView.contentSize.height - scrollView.frame.size.height + 100 {
            tableView.tableFooterView = createSpinnerFooter()

            bringAdditionalTransitionMetaData { [weak self] count in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }

                self?.cellCount += count
                guard let currentCellCount = self?.cellCount,
                      let maxCellCount = self?.transitionMetaDatas.count else {
                    return
                }

                if currentCellCount > maxCellCount {
                    self?.cellCount = maxCellCount
                }

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - ObjcMethod
private extension TransitionListViewController {
    @objc func didTapRecordButton() {
        let controller = RecordViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UIConfiguration
private extension TransitionListViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        setNavigationBar()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorStyle = .none
        setUpLayouts()
    }

    func setUpLayouts() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setNavigationBar() {
        let rightBarButton = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapRecordButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()

        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }

    func createSwipeActionImage(text: String) -> UIImage? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
        label.text = text
        label.sizeToFit()
        let renderer = UIGraphicsImageRenderer(bounds: label.bounds)
        let image = renderer.image { rendererContext in
            label.layer.render(in: rendererContext.cgContext)
        }

        return image
    }
}
