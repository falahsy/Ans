//
//  AnimalImagesPresenter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation

protocol IAnimalImagesPresenter {
    func presentImages(images: [Photo])
    func presentSaveFavoriteSuccess(log: String)
    func presentError(log: String)
}

class AnimalImagesPresenter: IAnimalImagesPresenter {
    
    weak var view: IAnimalImagesViewController?
    
    func presentImages(images: [Photo]) {
        view?.displayImages(images: images)
    }
    
    func presentError(log: String) {
        view?.displayError(log: log)
    }
    
    func presentSaveFavoriteSuccess(log: String) {
        view?.displaySaveFavoriteSuccess(log: log)
    }
}
