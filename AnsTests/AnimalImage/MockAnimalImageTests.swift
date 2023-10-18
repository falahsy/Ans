//
//  MockAnimalImageTests.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import XCTest
@testable import Ans

final class MockAnimalImageTests: XCTestCase {
    
    var view: MockAnimalImageViewController!
    var interactor: AnimalImagesInteractor!
    var presenter: MockAnimalImagePresenter!
    
    override func setUp() {
        super.setUp()
        view = MockAnimalImageViewController()
        presenter = MockAnimalImagePresenter()
        presenter.view = view
    }
    
    override func tearDown() {
        view = nil
        presenter = nil
        interactor = nil
        super.tearDown()
    }
    
    func setupSUT(worker: IImageWorker) {
        interactor = AnimalImagesInteractor(presenter: presenter, worker: worker)
    }
    
    func testGetImagesSuccess() {
        // given
        let worker = MockAnimalImageWorkerSuccess()
        setupSUT(worker: worker)
        
        // when
        interactor.getImages(query: "Elephant")
        
        // then
        let expectation = self.expectation(description: "Loading get data")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(worker.fetchImagestCalled)
        XCTAssertTrue(presenter.presenImagesCalled)
        XCTAssertTrue(view.displayImagesCalled)
        
        let photos = view.photos
        XCTAssertEqual(photos?.count, 15)
        
        let firstPhoto = photos!.first!.src.landscape
        XCTAssertEqual(firstPhoto, "https://images.pexels.com/photos/982021/pexels-photo-982021.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200")
    }
    
    func testGetImagesFailed() {
        // given
        let worker = MockAnimalImageWorkerFailed()
        setupSUT(worker: worker)
        
        // when
        interactor.getImages(query: "Elephant")
        
        // then
        XCTAssertTrue(worker.fetchImagestCalled)
        XCTAssertTrue(presenter.presentErrorCalled)
        XCTAssertTrue(view.displayErroCalled)
        
        XCTAssertNil(view.photos)
        XCTAssertNotNil(view.log)
    }
}
