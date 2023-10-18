//
//  AnimalResponse.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import Foundation

typealias AnimalListResponse = [Animal]

struct Animal: Codable {
    let name: String
}

class SpeciesAnimal {
    static let listAnimal: [String] = ["Elephant", "Lion", "Fox", "Dog", "Shark", "Turtle", "Whale", "Penguin"]
}
