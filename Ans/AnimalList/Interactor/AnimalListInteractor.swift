//
//  AnimalListInteractor.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Alamofire

protocol IAnimalListInteractor {
    func getAnimalList()
}

class AnimalListInteractor: IAnimalListInteractor {
    
    private let presenter: IAnimalListPresenter
    private let worker: IAnimalWorker
    
    private var animals: [Animal] = []
    
    init(presenter: IAnimalListPresenter, worker: IAnimalWorker) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func getAnimalList() {
        let disptachGroup = DispatchGroup()
        
        for animal in SpeciesAnimal.listAnimal {
            disptachGroup.enter()
            let request = AnimalApiRouter.getAnimal(name: animal)
            worker.fetchAnimalList(request: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    self.animals.append(contentsOf: response)
                    disptachGroup.leave()
                case .failure(let error):
                    self.presenter.presentError(log: error.localizedDescription)
                }
            }
        }
        
        disptachGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.presenter.presentAnimalList(animals: animals)
        }
    }
}
