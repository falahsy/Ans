//
//  AnimalFavoritesInteractor.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
import CoreData

protocol IAnimalFavoritesInteractor {
    func getFavoritesAnimal()
    func saveImages(animalFavorite: AnimalFavorite)
    func deleteImages(id: Int)
    func selectedFamily(family: String)
}

class AnimalFavoritesInteractor: IAnimalFavoritesInteractor {
    
    private let presenter: IAnimalFavoritesPresenter
    
    private var selectedFamily: String
    
    init(presenter: IAnimalFavoritesPresenter) {
        self.presenter = presenter
        self.selectedFamily = "All"
    }
    
    func getFavoritesAnimal() {
        let imagesFetch: NSFetchRequest<AnimalEntity> = AnimalEntity.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(imagesFetch)
            
            var animals: [AnimalFavorite] = []
            if selectedFamily == "All" {
                animals = generateAnimals(animmals: results)
            } else {
                let animalFilter = results.filter({ $0.family == selectedFamily })
                animals = generateAnimals(animmals: animalFilter)
            }
            presenter.presentAnimalFacorites(animals: animals)
        } catch let error as NSError {
            presenter.presentError(log: error.localizedDescription)
        }
    }
    
    private func generateAnimals(animmals: [AnimalEntity]) -> [AnimalFavorite] {
        return animmals.map { animal in
            return AnimalFavorite(id: Int(animal.id), name: animal.name ?? "", family: animal.family ?? "", liked: animal.liked, src: animal.src ?? "")
        }
    }
    
    func saveImages(animalFavorite: AnimalFavorite) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newAnimalFavorite = AnimalEntity(context: managedContext)
        newAnimalFavorite.setValue(animalFavorite.id, forKey: "id")
        newAnimalFavorite.setValue(animalFavorite.name, forKey: "name")
        newAnimalFavorite.setValue(animalFavorite.liked, forKey: "liked")
        newAnimalFavorite.setValue(animalFavorite.family, forKey: "family")
        newAnimalFavorite.setValue(animalFavorite.src, forKey: "src")
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        getFavoritesAnimal()
    }
    
    func deleteImages(id: Int) {
        let imagesFetch: NSFetchRequest<AnimalEntity> = AnimalEntity.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(imagesFetch)
            guard let deletedAnimal = results.filter({ $0.id == id }).first else { return }
            
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(deletedAnimal)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            getFavoritesAnimal()
        } catch let error as NSError {
            presenter.presentError(log: error.localizedDescription)
        }
    }
    
    func selectedFamily(family: String) {
        selectedFamily = family
    }
}
