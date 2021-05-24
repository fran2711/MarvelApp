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
    var total: Int = 0
    var offset: Int = 0
    
    func fetchCharacters(orderBy: String, completionResponse: @escaping(Result<[Character], Error>) -> Void) {
        APIConnection.shared.getCharactersList(limit: Constants.limit, offset: offset, orderBy: orderBy, onResult: { (response) in
            switch response {
            case .success(let apiResponse):
                if let total = apiResponse.data?.total {
                    self.total = total
                }
                
                self.offset += Constants.limit
                
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
    
    func fetchMoreCharacters(orderBy: String, completionResponse: @escaping(Result<[Character], Error>) -> Void) {
        APIConnection.shared.getCharactersList(limit: Constants.limit, offset: offset, orderBy: orderBy) { (response) in
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
                completionResponse(.failure(error))
                
            case .success(let apiResponse):
                if let results = apiResponse.data?.results {
                    self.offset += Constants.limit
                    self.characters.append(contentsOf: results)
                    completionResponse(.success(self.characters))
                }
            }
        }
    }
}
