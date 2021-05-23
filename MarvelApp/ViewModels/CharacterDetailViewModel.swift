//
//  CharacterDetailViewModel.swift
//  Marvel Heroes
//
//  Created by Fran Lucena on 28/11/2020.
//

import Foundation

class CharacterDetailViewModel {
    
    init(model: Character? = nil) {
        if let inputModel = model {
            character = inputModel
        }
    }
    
    var character = Character()
    
    func fetchCharacterDetail(id: Int, completionResponse: @escaping(Result<Character, Error>) -> Void) {
        APIConnection.shared.getCharacterDetail(id: id) { (response) in
            
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
                completionResponse(.failure(error))
            case .success(let apiResponse):
                if let results = apiResponse.data?.results, let character = results.first(where: { $0.id == id }) {
                    self.character =  character
                }
                completionResponse(.success(self.character))
            }
        }
    }
}
