//
//  AnimalFavoritesPresenter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation

protocol IAnimalFavoritesPresenter {
    func presentAnimalFacorites(animals: [AnimalFavorite])
    func presentError(log: String)
}

class AnimalFavoritesPresenter: IAnimalFavoritesPresenter {
    
    weak var view: IAnimalFavoritesViewController?
    
    func presentAnimalFacorites(animals: [AnimalFavorite]) {
        view?.displayAnimalFavorites(animals: animals)
    }
    
    func presentError(log: String) {
        view?.displaytError(log: log)
    }
}
