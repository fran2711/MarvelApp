//
//  APIConnection.swift
//  MarvelApp
//
//  Created by Fran Lucena on 22/5/21.
//

import Foundation

class APIConnection {
    static let shared = APIConnection()
    private init() {}
    
    let session = URLSession.shared
    
    func getCharactersList(limit: Int, offset: Int, orderBy: String, onResult: @escaping(Result<ApiResponse, Error>) -> Void){
        let params: [String: Any] = ["limit": limit, "offset": offset, "orderBy": orderBy]
        
        if let finalUrl = UtilFunctions.addKeyToUrl(url: Constants.basicUrl + Constants.characters, params: params) {
            let request = URLRequest(url: finalUrl)
            
            session.dataTask(with: request, completionHandler: { (data, _, error) in
                if let error = error {
                    print(error.localizedDescription)
                    onResult(.failure(error))
                } else if let data = data {
                    var apiResponse = ApiResponse()
                    do {
                        apiResponse = try JSONDecoder().decode(type(of: apiResponse), from: data)
                    } catch {
                        print(error.localizedDescription)
                        onResult(.failure(error))
                    }
                    onResult(.success(apiResponse))
                }
            }).resume()
        }
    }
    
    func getCharacterDetail(id: Int, onResult: @escaping(Result<Character, Error>) -> Void) {
        if let finalUrl = UtilFunctions.addKeyToUrl(url: Constants.basicUrl + Constants.charactersSlash + String(describing: id)) {
            let request = URLRequest(url: finalUrl)
            session.dataTask(with: request, completionHandler: { data, _, error in
                if let error = error {
                    print(error.localizedDescription)
                    onResult(.failure(error))
                } else if let data = data {
                    var character = Character()
                    do {
                        character = try JSONDecoder().decode(type(of: character), from: data)
                    } catch {
                        print(error.localizedDescription)
                        onResult(.failure(error))
                    }
                    onResult(.success(character))
                }
            }).resume()
        }
    }
}
