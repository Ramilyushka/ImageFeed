//
//  NetworkService.swift
//  ImageFeed
//
//  Created by Наиль on 06/10/23.
//

import Foundation

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseUrl: URL = Constants.defaultApiBaseURL) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseUrl)!)
        request.httpMethod = httpMethod
        return request
    }
}

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func object<T:Decodable> (
    for request: URLRequest,
    completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        
        return data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                Result { try decoder.decode(T.self, from: data) }
            }
            completion(response)
        }
    }
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fullFillCompletion: (Result<Data,Error>) -> Void = { result in
           DispatchQueue.main.async {
               completion(result)
           }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fullFillCompletion(.success(data))
                } else {
                    fullFillCompletion(.failure(NetworkError.httpStatusCode(statusCode))) //ошибки уровня HTTP ([HTTP 400/401/404], [HTTP 500], и тд])
                }
            } else if let error = error {
                fullFillCompletion(.failure(NetworkError.urlRequestError(error))) //[ошибки уровня URLSession] (прерванное соединение, таймаут и т.д.)
            } else {
                fullFillCompletion(.failure(NetworkError.urlSessionError)) //ошибки нарушения контракта URLSession
            }
        }
        task.resume()
        return task
    }
}
