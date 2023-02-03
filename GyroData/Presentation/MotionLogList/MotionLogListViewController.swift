//
//  MotionLogListViewController.swift
//  GyroData
//
//  Created by kjs on 2022/09/16.
//


import UIKit

fileprivate enum Titles {
    static let navigationItemTitle = "목록"
    static let leftNavigationButtonTitle = "측정"
}

final class MotionLogListViewController: UIViewController {
    
    // MARK: View(s)
    
    private let motionLogListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Override(s)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        combineViews()
        configureViewStyles()
        configureViewConstraints()
        configureNavigationItems()
    }
    
    //MARK: Private Function(s)
    
    private func configureViewStyles() {
        view.backgroundColor = .white
        motionLogListCollectionView.backgroundColor = .systemGray4
    }
    
    private func configureNavigationItems() {
        let leftNavigationButton = UIBarButtonItem(
            title: Titles.leftNavigationButtonTitle,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.title = Titles.navigationItemTitle
        navigationItem.rightBarButtonItem = leftNavigationButton
    }
    
    private func combineViews() {
        view.addSubview(motionLogListCollectionView)
    }
    
    private func configureViewConstraints() {
        NSLayoutConstraint.activate([
            motionLogListCollectionView.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor
                ),
            motionLogListCollectionView.bottomAnchor
                .constraint(
                    equalTo: view.bottomAnchor
                ),
            motionLogListCollectionView.leadingAnchor
                .constraint(
                    equalTo: view.leadingAnchor
                ),
            motionLogListCollectionView.trailingAnchor
                .constraint(
                    equalTo: view.trailingAnchor
                ),
        ])
    }
}
