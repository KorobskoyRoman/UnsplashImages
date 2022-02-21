//
//  LibraryViewController.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 07.02.2022.
//

import UIKit
import RealmSwift

class LibraryViewController: UIViewController {
    
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, Result>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Result>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, RealmImageModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RealmImageModel>
    
    var collectionView: UICollectionView!
//    var photos = [Result]()
    var photos: Results<RealmImageModel>!
    private let realm = try! Realm()
    private lazy var deleteAction: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
    }()
    private lazy var dataSource = createDiffableDataSource()
    private lazy var refreshButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
    }()
    
    enum Section: Int, CaseIterable {
        case mainSection
        
        func description() -> String {
            switch self {
            case .mainSection:
                return "Saved photos"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        title = "Library"
        
        setupNavBar()
        applySnapshot(animatingDifferences: false)
        loadPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        loadPhotos()
    }
    
    private func loadPhotos() {
        photos = realm.objects(RealmImageModel.self)
        applySnapshot(animatingDifferences: false)
        print(photos ?? [])
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainWhite()
        
        collectionView.register(LibraryCell.self, forCellWithReuseIdentifier: LibraryCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = deleteAction
        navigationItem.leftBarButtonItem = refreshButton
        navigationController?.hidesBarsOnTap = false
        deleteAction.isEnabled = true
        refreshButton.isEnabled = true
    }
    
    private func updateNavButtonsState() {
        deleteAction.isEnabled = photos.count > 0
    }
    
    @objc private func deleteBarButtonTapped() {
//        photos.removeAll()
/// -------------------------------------------------------------------------------------ДОБАВИТЬ УДАЛЕНИЕ ОБЪЕКТОВ -------------------------------------------------------------------------------------
        updateNavButtonsState()
        applySnapshot(animatingDifferences: true)
    }
    
    @objc private func refreshButtonTapped() {
        applySnapshot(animatingDifferences: true)
        updateNavButtonsState()
    }
    
    @objc private func tapPressed(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let cell = sender.view as? LibraryCell, let _ = self.collectionView.indexPath(for: cell) {
                let detailsVC = DetailsViewConroller()
                let image = cell.photo
                detailsVC.photoFromLibrary = image
                navigationController?.pushViewController(detailsVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            }
        }
    }
}

extension LibraryViewController {
    private func createCompositialLayout()  ->  UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Section not found")
            }
            switch section {
            case .mainSection:
                return self.createMainSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                
        let section = NSCollectionLayoutSection(group: group)
    
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}

extension LibraryViewController {
    private func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, image in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("No section")
            }
            switch section {
            case .mainSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCell.reuseId, for: indexPath) as! LibraryCell
                cell.photo = image
//                cell.photo.urlImage = image.urlImage
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPressed(sender:)))
                cell.addGestureRecognizer(tap)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("can't create new section header")}
            guard let section = Section(rawValue: indexPath.section) else { fatalError("No section kind") }
            sectionHeader.configurate(text: section.description(), font: UIFont(name: "Al Bayan Bold", size: 16), textColor: #colorLiteral(red: 0.6321875453, green: 0.636367023, blue: 0.6536904573, alpha: 1))
            
            return sectionHeader
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.mainSection])
        snapshot.appendItems(photos?.toArray() ?? [], toSection: .mainSection)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
