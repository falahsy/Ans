//
//  MockAnimalImageViewController.swift
//  AnsTests
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation
@testable import Ans

final class MockAnimalImageViewController: IAnimalImagesViewController {
    
    var displayImagesCalled: Bool!
    var displayErroCalled: Bool!
    
    var photos: [Photo]!
    var log: String!
    
    func displayImages(images: [Photo]) {
        displayImagesCalled = true
        self.photos = images
    }
    
    func displayError(log: String) {
        displayErroCalled = true
        self.log = log
    }
}
