//
//  MainTabBarController.swift
//  UnsplashImages
//
//  Created by Roman Korobskoy on 07.02.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photoVC = PhotoViewController()
        let libraryVC = LibraryViewController()
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719351113, blue: 0.4505646229, alpha: 1)
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let photoImage = UIImage(systemName: "photo.artframe", withConfiguration: boldConfig)
        let libraryImage = UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: boldConfig)
        
        viewControllers = [
            generateNavigationController(rootViewController: photoVC, title: "Search photo", image: photoImage!),
            generateNavigationController(rootViewController: libraryVC, title: "Library", image: libraryImage!)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
