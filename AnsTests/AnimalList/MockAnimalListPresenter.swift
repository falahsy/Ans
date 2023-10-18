//
//  MockAnimalListPresenter.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
@testable import Ans

final class MockAnimalListPresenter: AnimalListPresenter {

    var presenAnimalListCalled: Bool!
    var presentErrorCalled: Bool!
    
    override func presentAnimalList(animals: [Animal]) {
        super.presentAnimalList(animals: animals)
        presenAnimalListCalled = true
    }
    
    override func presentError(log: String) {
        super.presentError(log: log)
        presentErrorCalled = true
    }
}
