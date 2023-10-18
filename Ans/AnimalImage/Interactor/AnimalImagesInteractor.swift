//
//  AnimalImagesInteractor.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

protocol IAnimalImagesInteractor {
    var hasNext: Bool { get }
    func getImages(query: String)
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
                self.presenter.presentImages(images: self.photos)
            case .failure(let error):
                self.presenter.presentError(log: error.localizedDescription)
            }
        }
    }
}
