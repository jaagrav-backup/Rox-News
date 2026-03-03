//
//  APIManager.swift
//  RoxNews
//
//  Created by Jaagrav Seal on 01/03/26.
//

import Foundation

class APIManager {
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodingError(Error)
    }
    
    static func get<T: Decodable>(endpoint: String, type: T.Type) async throws -> T {
        guard let url = URL(string: Constants.newsApiBaseUrl + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue(Constants.newsApiAuthToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
