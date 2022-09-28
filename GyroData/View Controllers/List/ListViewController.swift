//
//  ListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//

import UIKit
import CoreData

final class ListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        return tableView
    }()

    private lazy var measureButton = UIBarButtonItem(title: "측정", style: .plain, target: self, action: #selector(didTapMeasureButton))

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
    }()

    private lazy var coreDataService: CoreDataService = {
        let container = appDelegate.coreDataStack.persistentContainer
        let service = CoreDataService(with: container, fetchedResultsControllerDelegate: self)
        return service
    }()

    private var isLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureLayout()
    }
    
    private func configureNavigation() {
        navigationItem.title = "목록"
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.rightBarButtonItem = measureButton
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.backgroundColor = .systemBackground

        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc
    private func didTapMeasureButton() {
        let measureViewController = MeasureViewController()
        navigationController?.pushViewController(measureViewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height

        if offset > contentHeight - tableView.bounds.size.height {
            if !isLoading {
                loadMoreData()
            }
        }
    }

    private func loadMoreData() {
        isLoading = true
        activityIndicator.startAnimating()
        coreDataService.loadMoreData() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreDataService.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let object = coreDataService.fetchedResultsController.object(at: indexPath)
        cell.dateLabel.text = object.date?.dateString
        cell.keyLabel.text = MotionType(rawValue: Int(object.type))?.displayText
        cell.valueLabel.text = String(object.lastTick)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let object = coreDataService.fetchedResultsController.object(at: indexPath)
        if let recordDate = object.date {
            let replayViewController = ReplayViewController()
            replayViewController.type = .view
            replayViewController.recordDate = recordDate
            navigationController?.pushViewController(replayViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let object = coreDataService.fetchedResultsController.object(at: indexPath)
        let playAction = UIContextualAction(style: .normal, title: "Play") { action, view, handler in
            let object = self.coreDataService.fetchedResultsController.object(at: indexPath)
            if let recordDate = object.date {
                let replayViewController = ReplayViewController()
                replayViewController.type = .replay
                replayViewController.recordDate = recordDate
                self.navigationController?.pushViewController(replayViewController, animated: true)
            }
        }
        playAction.backgroundColor = .systemGreen
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, handler in
            self.coreDataService.delete(object)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, playAction])
        return configuration
    }
}

extension ListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
