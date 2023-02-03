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
    private var isPaginating = false
    private var pageIndex = 0

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        loadListData()
    }
}

// MARK: - UITableViewDataSource
extension TransitionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransitionMetaData.transitionMetaDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? TransitionListCell ?? TransitionListCell()
        customCell.configureCell(data: TransitionMetaData.transitionMetaDatas[indexPath.row])
        return customCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
}

// MARK: - UITableViewDelegate
extension TransitionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let playAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            let metaData = TransitionMetaData.transitionMetaDatas[indexPath.row]
            self.presentPlayView(with: .play, metaData: metaData)
            
            completionHandler(true)
        }
        playAction.backgroundColor = .systemGreen
        playAction.image = createSwipeActionImage(text: "Play")

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            TransitionMetaData.transitionMetaDatas.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = createSwipeActionImage(text: "Delete")

        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let metaData = TransitionMetaData.transitionMetaDatas[indexPath.row]
        presentPlayView(with: .view, metaData: metaData)
    }
}

// MARK: - UIScrollViewDelegate
extension TransitionListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let triggerHeight = tableView.contentSize.height - scrollView.frame.size.height + 100
        let position = scrollView.contentOffset.y

        if triggerHeight > 0 && position > triggerHeight {
            guard !isPaginating else { return }
            isPaginating = true
            tableView.tableFooterView = createSpinnerFooter()

            bringAdditionalTransitionMetaData { [weak self] data in
                guard let self = self else { return }
                self.pageIndex += 1
                self.isPaginating = false
                TransitionMetaData.transitionMetaDatas.append(contentsOf: data)

                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Method
private extension TransitionListViewController {
    // Error타입 만들어주기
    func bringAdditionalTransitionMetaData(completion: @escaping ([TransitionMetaData]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            let data = PersistentContainerManager.shared.fetchTenTransitionMetaDatas(pageCount: self.pageIndex)
            completion(data)
        }
    }

    func loadListData() {
        let data = PersistentContainerManager.shared.fetchTenTransitionMetaDatas(pageCount: pageIndex)
        pageIndex += 1
        isPaginating = false
        TransitionMetaData.transitionMetaDatas.append(contentsOf: data)

        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
    
    func presentPlayView(with type: PlayViewController.viewType, metaData: TransitionMetaData) {
        let controller = PlayViewController(viewType: type, metaData: metaData)
        
        navigationController?.pushViewController(controller, animated: true)
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
        tableView.register(TransitionListCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
        rightBarButton.setTitleTextAttributes([.font: UIFont.preferredFont(forTextStyle: .title3)], for: .normal)
        let titleLable = UILabel()
        titleLable.text = "목록"
        titleLable.font = UIFont.preferredFont(forTextStyle: .title1)
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.titleView = titleLable
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
        let metrics = UIFontMetrics(forTextStyle: .title2)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: .heavy)
        label.font = metrics.scaledFont(for: font)
        label.font = UIFont.preferredFont(for: .title2, weight: .heavy)
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
