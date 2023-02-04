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
    
    private var metaDatas: [TransitionMetaData] = []
    private var isPaginating = false
    private var pageIndex = 1

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReloadData()
    }
}

// MARK: - UITableViewDataSource
extension TransitionListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return metaDatas.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let transitionListCell = tableView.dequeueReusableCell(
            withIdentifier: TransitionListCell.identifier, for: indexPath
        ) as? TransitionListCell else {
            return UITableViewCell()
        }
        let metaData = metaDatas[indexPath.row]
        transitionListCell.configureCell(data: metaData)
        
        return transitionListCell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return view.frame.height / 7
    }
}

// MARK: - UITableViewDelegate
extension TransitionListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playAction = swipePlayAction(indexPath: indexPath)
        let deleteAction = swipeDeleteAction(indexPath: indexPath)
    
        return UISwipeActionsConfiguration(actions: [deleteAction, playAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let metaData = metaDatas[indexPath.row]
        presentPlayView(with: .view, metaData: metaData)
    }
}

// MARK: - UIScrollViewDelegate
extension TransitionListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let triggerHeight = tableView.contentSize.height - scrollView.frame.size.height + 100
        let position = scrollView.contentOffset.y
        
        guard (triggerHeight > 0) && (position > triggerHeight),
              isPaginating == false else {
            return
        }
        
        isPaginating = true
        tableView.tableFooterView = createIndicatorFooter()

        fetchData { [weak self] fetchedData in
            guard let self = self,
                  fetchedData.isEmpty == false else {
                
                self?.resetFooterView()
                return
            }
            
            self.pageIndex += 1
            self.metaDatas.append(contentsOf: fetchedData)
            
            self.resetFooterView()
        }
    }
    
    func resetFooterView() {
        isPaginating = false
        
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }
    }
}

// MARK: - Method
private extension TransitionListViewController {
    func fetchData(completion: @escaping ([TransitionMetaData]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            let fetchData = PersistentContainerManager
                .shared
                .fetchTransitionMetaData(pageCount: self.pageIndex)
            completion(fetchData)
        }
    }

    func fetchReloadData() {
        let data = PersistentContainerManager.shared.fetchReloadData(pageCount: self.pageIndex)
        metaDatas = data
        tableView.reloadData()
    }
    
    func presentPlayView(with type: PlayViewController.viewType, metaData: TransitionMetaData) {
        let controller = PlayViewController(viewType: type, metaData: metaData)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func swipePlayAction(indexPath: IndexPath) -> UIContextualAction {
        let playAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, handler in
            guard let self = self else { return }
            
            let metaData = self.metaDatas[indexPath.row]
            self.presentPlayView(with: .play, metaData: metaData)
            
            handler(true)
        }
        playAction.backgroundColor = .systemGreen
        playAction.image = createSwipeActionImage(text: "Play")
        
        return playAction
    }
    
    func swipeDeleteAction(indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, handler in
            guard let self = self else { return }
            let data = self.metaDatas[indexPath.row]
            PersistentContainerManager.shared.deleteTransitionMetaData(data: data)
            
            self.fetchReloadData()
            handler(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = createSwipeActionImage(text: "Delete")
        
        return deleteAction
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
        tableView.register(
            TransitionListCell.self,
            forCellReuseIdentifier: TransitionListCell.identifier
        )
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
        let rightBarButton = UIBarButtonItem(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(didTapRecordButton)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "목록"
    }

    func createIndicatorFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 5))
        let indicator = UIActivityIndicatorView()

        indicator.center = footerView.center
        footerView.addSubview(indicator)
        indicator.startAnimating()

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
