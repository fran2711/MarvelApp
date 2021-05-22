//
//  CharactersListViewModel.swift
//  Marvel Heroes
//
//  Created by Fran Lucena on 28/11/2020.
//

import Foundation

class CharactersListViewModel {
    init(model: [Character]? = nil) {
        if let inputModel = model {
            characters = inputModel
        }
    }
    
    var characters = [Character]()
    
    func fetchCharacters(offset: Int, orderBy: String, completionResponse: @escaping(Result<[Character], Error>) -> Void) {
        APIConnection.shared.getCharactersList(limit: 50, offset: offset, orderBy: orderBy, onResult: { (response) in
            switch response {
            case .success(let apiResponse):
                if let results = apiResponse.data?.results {
                    self.characters = results
                    completionResponse(.success(self.characters))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionResponse(.failure(error))
            }
        })
    }
    
//    func fetchMoreCharacters(offset: Int, orderBy: String, completion: @escaping(Result<Characters, Error>) -> Void) {
//        ApiConnection.shared.getCharactersList(limit: 50, offset: offset, orderBy: orderBy) { (response) in
////
////            response.model.list?.forEach({ (character) in
////                self.characters.list?.append(character)
////            })
////
//            completion(response)
//
//        }
//    }
}
