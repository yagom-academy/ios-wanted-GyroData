//
//  MainViewController.swift
//  GyroData
//
//  Created by inho on 2023/02/03.
//

import UIKit

final class MainViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, MotionData>
    
    enum Section {
        case main
    }
    
    //MARK: Properties
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MotionDataCell.self, forCellReuseIdentifier: MotionDataCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    private var mainDataSource: DataSource?
    private var mainViewModel: MainViewModel = .init()
    private var isPaging: Bool = false {
        didSet {
            if isPaging {
                mainViewModel.increaseOffset()
                isPaging.toggle()
            }
        }
    }

    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
        configureDataSource()
        bindViewModel()
        mainTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainViewModel.fetchDatas()
    }
    
    //MARK: Private Methods
    
    private func configureNavigationBar() {
        navigationItem.title = "목록"
        navigationItem.rightBarButtonItem = .init(
            title: "측정",
            style: .plain,
            target: self,
            action: #selector(tapRightBarButton)
        )
    }
    
    @objc private func tapRightBarButton() {
        let measureViewModel = MeasureViewModel()
        let graphViewModel = GraphViewModel()
        let measureViewController = MeasureViewController(
            measureViewModel: measureViewModel,
            graphViewModel: graphViewModel
        )
        
        show(measureViewController, sender: nil)
    }
    
    private func configureView() {
        view.addSubview(mainTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        mainViewModel.bindData { [weak self] motionDatas in
            self?.configureSnapShot(motionDatas: motionDatas)
        }
    }
}

//MARK: - UITableViewDiffableDataSource

extension MainViewController {
    private func configureDataSource() {
        mainDataSource = DataSource(tableView: mainTableView) { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MotionDataCell.identifier,
                for: indexPath
            ) as? MotionDataCell else {
                return UITableViewCell()
            }
            
            let cellViewModel = MotionCellViewModel(motionData: data)
            
            cell.configureViewModel(cellViewModel)
            cellViewModel.convertCellData()
            
            return cell
        }
    }
    
    private func configureSnapShot(motionDatas: [MotionData]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MotionData>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(motionDatas)
        
        mainDataSource?.apply(snapShot, animatingDifferences: true)
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moveToDetailView(indexPath: indexPath, pageType: .view)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let playButton = UIContextualAction(style: .normal, title: "Play") { _, _, completion in
            self.moveToDetailView(indexPath: indexPath, pageType: .play)
            completion(true)
        }
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.mainViewModel.deleteData(at: indexPath.row)
        }
        
        playButton.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [deleteButton, playButton])
    }
    
    private func moveToDetailView(indexPath: IndexPath, pageType: PageType) {
        guard let motionData = mainDataSource?.itemIdentifier(for: indexPath),
              let fileManager = FileHandleManager() else { return }
        
        let detailViewModel = DetailViewModel(motionData, by: pageType, fileManager: fileManager)
        let detailViewController = DetailViewController(viewModel: detailViewModel, graphViewModel: GraphViewModel())
        
        show(detailViewController, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.height < scrollView.contentSize.height,
              !isPaging
        else {
            return
        }

        if scrollView.frame.height + scrollView.contentOffset.y >= scrollView.contentSize.height,
           mainViewModel.hasNext {
            isPaging = true
        }
    }
}
