//
//  APIManager.swift
//  Weather
//
//  Created by Dhruv Ukani on 06/10/23.
//

import Foundation
protocol APIRouter
{
    var host:        String { get }
    var schema:      String{ get}
    var path:        String {get}
    var methode:     String {get}
    var queryItems:  [URLQueryItem]{get}
    var headers:     [(String,String)]{get}
    var statusCode:  Int{get}
    var body:        Codable? {get}
}


enum APIRequestError: Error {
    case badUrl, noData, invalidResponce,encodeError(Error),invalidData,decodeError(Error)
}

typealias Handler<T> = (Result<T, APIRequestError>) -> Void


final class APIManager
{
    static let shared = APIManager()
    private init() {}
    
    func request<T:Codable> (apiRouter:APIRouter,
                               modelType:T.Type,
                               completion: @escaping Handler<T>)
    {
        
        //  MARK: - Components
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.schema
        components.path = apiRouter.path
        components.queryItems = apiRouter.queryItems

        // MARK: - URL
        guard let url = components.url else {
            completion(.failure(.badUrl))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRouter.methode
        
        //  MARK: - Headder
        apiRouter.headers.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        //  MARK: - Body
        if let requestBody = apiRouter.body {
            do{
                let data = try JSONEncoder().encode(requestBody)
                urlRequest.httpBody = data
            }
            catch{
                completion(.failure(.encodeError(error)))
            }
            
        }
        
        //  MARK: - API Call
        URLSession.shared.dataTask(with: urlRequest) { data, responce, error in
            
            // MARK: - Data & Error Checking
            guard let data = data , error == nil else {
                completion(.failure(.invalidData))
                return
            }
            //  MARK: - StatusCode Checking
            guard let httpResponse = responce as? HTTPURLResponse,
                  httpResponse.statusCode == apiRouter.statusCode else {
                completion(.failure(.invalidResponce))
                return
            }
            //  MARK: - Decoding Data
            do {
                let responce = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responce))
            } catch {
                print("Decoding Error in API Router : \(error)")
                completion(.failure(.decodeError(error)))
            }
            
        }.resume()
    }
    
}

