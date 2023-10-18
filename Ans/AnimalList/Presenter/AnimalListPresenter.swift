//
//  AnimalListPresenter.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation

protocol IAnimalListPresenter {
    func presentAnimalList(animals: [Animal])
    func presentError(log: String)
}

class AnimalListPresenter: IAnimalListPresenter {
    
    weak var view: IAnimalListViewController?
    
    func presentAnimalList(animals: [Animal]) {
        view?.displayAnimalList(animals: animals)
    }
    
    func presentError(log: String) {
        view?.displayError(log: log)
    }
}
