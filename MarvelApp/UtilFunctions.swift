//
//  UtilFunctions.swift
//  MarvelApp
//
//  Created by Fran Lucena on 22/5/21.
//

import Foundation
import CryptoKit
class UtilFunctions {

    static func addKeyToUrl(url: String, params: [String: Any]? = nil) -> URL? {
        let date = Date().timeIntervalSince1970
        let md5Hex = self.getMD5Hex(date: date)
        guard var paramArray = params else {
            let publicKey = URLQueryItem(name:"apikey", value: Constants.publicApiKey)
            let dateData = URLQueryItem(name:"ts", value: "\(date)")
            let hash = URLQueryItem(name:"hash", value: md5Hex)
            return URL(string: addToUrlQueryParams(url: url, params: [publicKey, hash, dateData]))
        }
        paramArray["ts"] = String(describing: date)
        paramArray["apikey"] = Constants.publicApiKey
        paramArray["hash"] = md5Hex
        return URL(string: addToUrlQueryParams(url: url, params: URLQueryItem.fromDictionary(dictionary: paramArray)))
    }
    
    
    static func getMD5Hex(date: Double) -> String {
        let md5String = String(describing: date) + Constants.privateApiKey + Constants.publicApiKey
        if let data = md5String.data(using: .utf8) {
            let md5Data = Insecure.MD5.hash(data: data)
            return  md5Data.map { String(format: "%02hhx", $0) }.joined()
        } else {
            return ""
        }
    }
    
    static func addToUrlQueryParams(url: String, params: [URLQueryItem]?) -> String {
        guard var urlComponents = URLComponents(string: url) else {
            return ""
        }
        urlComponents.queryItems = params
        guard let urlFinalString = urlComponents.url?.absoluteString else {
            return ""
        }
        return urlFinalString
    }
    
    
    static func getImageUrl(path: String, extensionString: String) -> String {
        let httpUrl = path + "." + extensionString
        guard var components = URLComponents(string: httpUrl) else {
            return httpUrl
        }
        components.scheme = "https"
        if let string = components.string {
            return string
        } else {
            return httpUrl
        }
    }
}



extension URLQueryItem {
    static func fromDictionary(dictionary: [String: Any]) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        for (key, value) in dictionary {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        return queryItems
    }
}
