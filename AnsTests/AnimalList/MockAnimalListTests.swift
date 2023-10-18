//
//  MockAnimalListTests.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import XCTest
@testable import Ans

final class MockAnimalListTests: XCTestCase {
    
    var view: MockAnimalListViewController!
    var interactor: AnimalListInteractor!
    var presenter: MockAnimalListPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockAnimalListViewController()
        presenter = MockAnimalListPresenter()
        presenter.view = view
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        interactor = nil
        super.tearDown()
    }
    
    func setupSUT(worker: IAnimalWorker) {
        interactor = AnimalListInteractor(presenter: presenter, worker: worker)
    }
    
    func testGetAnimalListSuccess() {
        // given
        let worker = MockAnimalListWorkerSuccess()
        setupSUT(worker: worker)
        
        // when
        interactor.getAnimalList()
        
        // then
        let expectation = self.expectation(description: "Loading get data")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(worker.fetchAnimalListCalled)
        XCTAssertTrue(presenter.presenAnimalListCalled)
        XCTAssertTrue(view.displayAnimalListCalled)
        
        let animals = view.animals
        XCTAssertEqual(animals?.count, 80)
        
        let firstAnimal = animals!.first!.name
        XCTAssertEqual(firstAnimal, "African Bush Elephant")
    }
    
    func testGetPokdexFailed() {
        // given
        let worker = MockAnimalListWorkerFailed()
        setupSUT(worker: worker)
        
        // when
        interactor.getAnimalList()
        
        // then
        XCTAssertTrue(worker.fetchAnimalListCalled)
        XCTAssertTrue(presenter.presentErrorCalled)
        XCTAssertTrue(view.displayErroCalled)
        
        XCTAssertNil(view.animals)
        XCTAssertNotNil(view.log)
    }
}
