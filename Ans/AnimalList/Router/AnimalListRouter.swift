//
//  AnimalListRouter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

protocol IAnimalListRouter {
    func navigateToPokemonDetail(from originView: AnimalListViewController, animal: Animal)
}

class AnimalListRouter: IAnimalListRouter {

    func navigateToPokemonDetail(from originView: AnimalListViewController, animal: Animal) {
        let destinationView = AnimalImagesViewController(animal: animal)
        destinationView.hidesBottomBarWhenPushed = true
        originView.navigationController?.pushViewController(destinationView, animated: true)
    }
}
