//
//  ApiManager.swift
//  WeatherAppRecruitment
//
//  Created by Rafal Kampa on 12/09/2023.
//

import Foundation
import Alamofire

// MARK: - WeatherDataError
enum WeatherDataError: Error {
    case invalidInput
}

// MARK: - ApiManager
final class ApiManager {
    static let shared = ApiManager()
    
    func getData<T: Decodable>(path: String, params: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = ApiDefines.API_BASE_URL + path
        AF.request(urlString,
                   method: .get,
                   parameters: prepareParams(params: params))
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decodedResponse):
                completion(.success(decodedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func prepareParams(params: [String: Any]) -> [String: Any] {
        var paramsWithKey = params
        paramsWithKey["appid"] = ApiDefines.API_KEY
        
        return paramsWithKey
    }
}
