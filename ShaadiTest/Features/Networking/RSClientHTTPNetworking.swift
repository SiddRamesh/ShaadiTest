
//
//  ShaadiTest
//
//  Created by Ramesh Siddanavar on 30/09/20.
//

import Foundation

enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data"
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}


extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}

enum Result<T, U, V: Error> {
    case success(T)
    case failure(U)
    case Validation(V)
}

protocol RSDataProvider {
    func fetchRemote<Model: Codable>(_ val: Model.Type, api: String, completion: @escaping (Result<Codable, DataResponseError, DataResponseError>) -> Void)
}

final class RSClientHTTPNetworking : RSDataProvider {
   
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchRemote<Model: Codable>(_ val: Model.Type, api: String,
                         completion: @escaping (Result<Codable, DataResponseError, DataResponseError>) -> Void) {
        if let api = URL(string: api) {
            let urlRequest = URLRequest(url: api)
            session.dataTask(with: urlRequest, completionHandler: { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.hasSuccessStatusCode,
                    let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
                }
                guard let decodedResponse = try? JSONDecoder().decode(Model.self, from: data) else {
                    completion(Result.failure(DataResponseError.decoding))
                    return
                }
                completion(Result.success(decodedResponse))
            }).resume()
        }
    }
}
