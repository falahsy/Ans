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
    let taxonomy: Taxonomy
}

class SpeciesAnimal {
    static let listAnimal: [String] = ["Elephant", "Lion", "Fox", "Dog", "Shark", "Turtle", "Whale", "Penguin"]
}

struct Taxonomy: Codable {
    let family: String?
}

struct AnimalFavorite {
    let id: Int
    let name: String
    let family: String
    let liked: Bool
    let src: String
}
