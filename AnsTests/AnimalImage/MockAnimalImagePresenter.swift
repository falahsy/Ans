//
//  MockAnimalImagePresenter.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
@testable import Ans

final class MockAnimalImagePresenter: AnimalImagesPresenter {

    var presenImagesCalled: Bool!
    var presentErrorCalled: Bool!
    
    override func presentImages(images: [Photo]) {
        super.presentImages(images: images)
        presenImagesCalled = true
    }
    
    override func presentError(log: String) {
        super.presentError(log: log)
        presentErrorCalled = true
    }
}
