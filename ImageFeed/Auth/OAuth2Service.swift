//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Наиль on 27/08/23.
//

import Foundation

final class OAuth2Service {
    
    //static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get { return OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue ?? "" }
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
        
        currentTask =  object(for: request) {[weak self] result in
            self?.currentTask = nil
            guard let self = self else {return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        //self.currentTask = task
        //currentTask?.resume()
    }
}

extension OAuth2Service {
    
    private struct OAuthTokenResponseBody: Codable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseUrl:  URL(string: "https://unsplash.com")!)
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}

// MARK: - HTTP Request
extension URLRequest {
    static func makeHTTPRequest(path: String, httpMethod: String, baseUrl: URL = Constants.defaultBaseURL) -> URLRequest {
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
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fullFillCompletion: (Result<Data,Error>) -> Void = { result in
           DispatchQueue.main.async {
               print("queue 🟢")
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
