//
//  MockAnimalListViewController.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
@testable import Ans

final class MockAnimalListViewController: IAnimalListViewController {
    
    var displayAnimalListCalled: Bool!
    var displayErroCalled: Bool!
    
    var animals: [Animal]!
    var log: String!
    
    func displayAnimalList(animals: [Animal]) {
        displayAnimalListCalled = true
        self.animals = animals
    }
    
    func displayError(log: String) {
        displayErroCalled = true
        self.log = log
    }
}
