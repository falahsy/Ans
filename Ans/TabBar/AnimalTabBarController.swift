//
//  AnimalTabBarController.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

class AnimalTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animalListView = AnimalListViewController()
        let animalListNavigationController = UINavigationController(rootViewController: animalListView)
        let animalImage = UIImage(systemName: "list.bullet")
        animalListNavigationController.tabBarItem = UITabBarItem(title: "Animals", image: animalImage, selectedImage: animalImage)
        
        let animalFavoritesView = AnimalFavoritesViewController()
        let animalFavoritesNavigationController = UINavigationController(rootViewController: animalFavoritesView)
        let favoriteImage = UIImage(systemName: "star")
        animalFavoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: favoriteImage, selectedImage: favoriteImage)
        
        viewControllers = [animalListNavigationController, animalFavoritesNavigationController]
    }

}
