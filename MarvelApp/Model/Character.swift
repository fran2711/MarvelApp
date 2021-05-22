//
//  Characters.swift
//  MarvelApp
//
//  Created by Fran Lucena on 22/5/21.
//

import Foundation

struct Character: Codable {
    var id: Int?
    var name: String?
    var description: String? //(string, optional): A short bio or description of the character.
    var modified: String? //(Date, optional): The date the resource was most recently modified.
    var thumbnail: Thumbnail? //(Image, optional): The representative image for this character.
    var resourceURI: String? //(string, optional): The canonical URL identifier for this resource.
    var comics: CharacterElements?
    var series: CharacterElements?
    var stories: CharacterElements?
    var events: CharacterElements?
    var urls: [CharacterUrl]?
}

struct Thumbnail: Codable {
    var path: String?
    var `extension`: String?
}

struct CharacterElements: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [ElementItems]?
    var returned: Int?
}

struct ElementItems: Codable {
    var resourceURI: String?
    var name: String?
    var type: String?
}

struct CharacterUrl: Codable {
    var type: String?
    var url: String?
}
