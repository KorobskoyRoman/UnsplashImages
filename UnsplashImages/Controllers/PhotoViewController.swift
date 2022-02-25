//
//  PhotoViewController.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 07.02.2022.
//

import UIKit
import SDWebImage
import RealmSwift

class PhotoViewController: UIViewController {
        
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Result>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Result>

    private var collectionView: UICollectionView!
    private var timer: Timer?
    private let networkManager = NetworkManager()
    private var images = [Result]()
    private var popularImages = [Result]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var selectedImages = [UIImage]()
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    private var page: Int = 1
    
    private lazy var dataSource = createDiffableDataSource()
    private lazy var addAction: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    private lazy var shareAction: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareActionTapped))
    }()
    let realm = try! Realm()
    
    enum Section: Int, CaseIterable {
        case popular, mainSection
        
        func description() -> String {
            switch self {
            case .mainSection:
                return "Search results"
            case .popular:
                return "Popular photos"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchBar(searchController.searchBar, textDidChange: "popular")
        setupSearchBar()
        setupCollectionView()
        applySnapshot(animatingDifferences: false)
        setupNavBar()
        collectionView.delegate = self
        
        self.networkManager.fetchPopular(page: 1, completion: { searchResults in
            self.popularImages = searchResults
            DispatchQueue.main.async {
                self.applySnapshot()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func updateNavButtonsState() {
        addAction.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }
    
// MARK: - Setup elements
    
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
        collectionView.allowsMultipleSelection = true
        title = "Photos"
        collectionView.delegate = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        collectionView.register(PopularPhotoCell.self, forCellWithReuseIdentifier: PopularPhotoCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = addAction
        navigationItem.leftBarButtonItem = shareAction
        navigationController?.hidesBarsOnTap = false
        addAction.isEnabled = true
    }
    
    @objc private func addBarButtonTapped() {
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photos, indexPath) -> [Result] in
            var mutablePhotos = photos
            let photo = images[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })
        let alert = UIAlertController(title: "", message: "\(selectedPhotos!.count) фото будут добавлены в избранное", preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { action in
            let tabbar = self.tabBarController as! MainTabBarController
            let navVC = tabbar.viewControllers?[1] as! UINavigationController
            let libraryVC = navVC.topViewController as! LibraryViewController

//            libraryVC.photos.append(contentsOf: selectedPhotos ?? [])
            self.refresh()
            
            let imageModel = RealmImageModel()
            selectedPhotos?.forEach({ image in
                imageModel.urlImage = image.urls["regular"]!
            })
            RealmManager.shared.saveImageModel(photo: imageModel)
        }
        
        let cancel = UIAlertAction(title: "Отменa", style: .cancel) { action in }
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc private func shareActionTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc private func longPressTapped(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("long press")
            if let cell = sender.view as? PhotoCell, let _ = self.collectionView.indexPath(for: cell) {
                let detailsVC = DetailsViewConroller()
                let image = cell.photo
                detailsVC.photo = image
                navigationController?.pushViewController(detailsVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
    @objc private func tapPressTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("popular pressed")
            if let cell = sender.view as? PopularPhotoCell, let _ = self.collectionView.indexPath(for: cell) {
                let detailsVC = DetailsViewConroller()
                let image = cell.photo
                detailsVC.photo = image
                navigationController?.pushViewController(detailsVC, animated: true)
                tabBarController?.tabBar.isHidden = true
            }
        }
    }
}

// MARK: - Create layout

extension PhotoViewController {
    private func createCompositialLayout() ->  UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Section not found")
            }
            switch section {
            case .mainSection:
                return self.createMainSection()
            case .popular:
                return self.createPopularSection()
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
    
    private func createPopularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        
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

// MARK: - Create data source

extension PhotoViewController {
    
    private func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, image in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("No section")
            }
            switch section {
            case .popular:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularPhotoCell.reuseId, for: indexPath) as! PopularPhotoCell
                cell.photo = image
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPressTapped(sender:)))
                cell.addGestureRecognizer(tap)
                return cell
            case .mainSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
                cell.photo = image
                let longTap = UILongPressGestureRecognizer(target: self, action: #selector((self.longPressTapped(sender:))))
                cell.addGestureRecognizer(longTap)
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
        
        snapshot.appendSections([.popular, .mainSection])
        snapshot.appendItems(images, toSection: .mainSection)
        snapshot.appendItems(popularImages, toSection: .popular)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("No section")
        }
        switch section {
        case .popular:
            return
        case .mainSection:
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
            guard let image = cell.imagePhoto.image else { return }
            selectedImages.append(image)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        guard let image = cell.imagePhoto.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
    
// MARK: Pagination
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .popular:
            let position = collectionView.contentOffset.x
            if position > (collectionView.contentSize.width - 1 - collectionView.bounds.size.width) {
                networkManager.fetchPopular(page: page) { [weak self] results in
                    let newData = results
                    self?.popularImages.append(contentsOf: newData)
                    DispatchQueue.main.async {
                        self?.applySnapshot(animatingDifferences: true)
                    }
                }
                page += 1
                print(page)
            }
        case .mainSection:
            // not done yet
            return
        }
    }
}

// MARK: - UISearchBarDelegate

extension PhotoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.collectionView.showLoading(style: .large, color: .cyan)
            self.networkManager.fetchPhotos(page: self.page, searchText: searchText) { [weak self] searchResults in
                self?.images = searchResults.results
                DispatchQueue.main.async {
                    self?.applySnapshot()
                    self?.collectionView.stopLoading()
                }
            }
        })
    }
}

extension PhotoViewController: UIGestureRecognizerDelegate {
}

// MARK: - SwiftUI

import SwiftUI

struct ChatCellControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all).previewInterfaceOrientation(.portrait)
    }
    
    struct ContainerView: UIViewControllerRepresentable {

        let tabbarVC = MainTabBarController()
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            return tabbarVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

