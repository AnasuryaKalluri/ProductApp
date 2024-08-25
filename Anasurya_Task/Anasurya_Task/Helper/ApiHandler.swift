//
//  ApiHandler.swift
//  Anasurya_Task
//
//  Created by Anasurya on 24/08/2024.
//

import Foundation

class APIService {
    static let shared = APIService()

    // Generic method for all requests except those expecting `Void`
    func performRequest<T: Decodable>(endpoint: String, method: String, body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // Special method for requests expecting `Void`
    func deleteRequest(endpoint: String, method: String, body: Data? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com\(endpoint)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Successful request, no data expected
            completion(.success(()))
        }

        task.resume()
    }
}
