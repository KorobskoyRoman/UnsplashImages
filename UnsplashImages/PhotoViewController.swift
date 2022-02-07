//
//  PhotoViewController.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 07.02.2022.
//

import UIKit

class PhotoViewController: UIViewController {

    var photos = [ImageModel]()
    var collectionView: UICollectionView!
    private var timer: Timer?
    private let networkManager = NetworkManager()
    private var images: ImageModel?
    private let searchController = UISearchController(searchResultsController: nil)
    
    enum Section: Int, CaseIterable {
        case mainSection
        
        func description() -> String {
            switch self {
            case .mainSection:
                return "Main"
            }
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ImageModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchBar(searchController.searchBar, textDidChange: "popular")
        setupSearchBar()
        setupCollectionView()
        reloadData()
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainWhite()
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ImageModel>()
        
        snapshot.appendSections([.mainSection])
        snapshot.appendItems(photos, toSection: .mainSection)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension PhotoViewController {
    private func createCompositialLayout() ->  UICollectionViewLayout {
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        
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

extension PhotoViewController {
//    private func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, ImageModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
//            guard let section = Section(rawValue: indexPath.section) else {
//                fatalError("No section")
//            }
//            switch section {
//            case .mainSection:
//                return self.configure(collectionView: collectionView, cellType: PhotoCell.self, with: photo, for: indexPath)
//            }
//        })
//
//        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
//            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("can't create new section header")}
//            guard let section = Section(rawValue: indexPath.section) else { fatalError("No section kind") }
//            sectionHeader.configurate(text: section.description(), font: .laoSangamMN20(), textColor: #colorLiteral(red: 0.6321875453, green: 0.636367023, blue: 0.6536904573, alpha: 1))
//
//            return sectionHeader
//        }
//    }
}

// MARK: - UISearchBarDelegate

extension PhotoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.networkManager.fetchPhotos(searchText: searchText) { [weak self] searchResults in
            self?.images = searchResults
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

