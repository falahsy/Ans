//
//  AnimalImagesInteractor.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire
import CoreData

protocol IAnimalImagesInteractor {
    var hasNext: Bool { get }
    func getImages(query: String)
    func saveImages(animalFavorite: AnimalFavorite)
    func deleteImages(id: Int)
}

class AnimalImagesInteractor: IAnimalImagesInteractor {
    
    private let presenter: IAnimalImagesPresenter
    private let worker: IImageWorker
    
    private var currentPage: Int = 1
    private var nextPage: String? = nil
    
    private var photos: [Photo] = []
    
    var hasNext: Bool {
        return nextPage != nil
    }
    
    init(presenter: IAnimalImagesPresenter, worker: IImageWorker) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func getImages(query: String) {
        let request = ImageApiRouter.getAnimalImage(query: query, page: currentPage)
        worker.fetchImages(request: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                if let _ = response.nextPage {
                    currentPage += 1
                }
                self.nextPage = response.nextPage
                self.photos.append(contentsOf: response.photos)
                self.checkLocalData()
            case .failure(let error):
                self.presenter.presentError(log: error.localizedDescription)
            }
        }
    }
    
    private func checkLocalData() {
        let imagesFetch: NSFetchRequest<AnimalEntity> = AnimalEntity.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(imagesFetch)
            for i in 0..<results.count {
                for animal in results {
                    if photos[i].id == animal.id {
                        photos[i].liked = animal.liked
                    }
                }
            }
            presenter.presentImages(images: photos)
        } catch let error as NSError {
            presenter.presentError(log: error.localizedDescription)
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
        let status = animalFavorite.liked ? "added to favorites" : "removed from favorites"
        checkLocalData()
        presenter.presentSaveFavoriteSuccess(log: "Image has been \(status)")
    }
    
    func deleteImages(id: Int) {
        let imagesFetch: NSFetchRequest<AnimalEntity> = AnimalEntity.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(imagesFetch)
            guard let deletedAnimal = results.filter({ $0.id == id }).first else { return }
            
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(deletedAnimal)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            checkLocalData()
        } catch let error as NSError {
            presenter.presentError(log: error.localizedDescription)
        }
    }
}
