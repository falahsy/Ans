//
//  AnimalListRouter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

protocol IAnimalListRouter {
    func navigateToPokemonDetail(from originView: AnimalListViewController, animalName: String)
}

class AnimalListRouter: IAnimalListRouter {

    func navigateToPokemonDetail(from originView: AnimalListViewController, animalName: String) {
        let destinationView = AnimalImagesViewController(animalName: animalName)
        destinationView.hidesBottomBarWhenPushed = true
        originView.navigationController?.pushViewController(destinationView, animated: true)
    }
}
