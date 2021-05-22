//
//  ApiResponse.swift
//  MarvelApp
//
//  Created by Fran Lucena on 22/5/21.
//

import Foundation


struct ApiResponse: Codable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var etag: String?
    var data: Data?
}

struct Data: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [Character]?
}
