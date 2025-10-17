//
//  NetworkManager.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 17/10/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let baseUrl = "https://oapaiqtgkr6wfbum252tswprwa0ausnb.lambda-url.eu-central-1.on.aws"
    private let queryParameter = "input"
    /// Generic GET request that decodes a response model
    func request<ResponseData: Decodable>(
        searchValue: String,
        responseType: ResponseData.Type
    ) async throws -> ResponseData {
        
        guard var components = URLComponents(string: baseUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: queryParameter, value: searchValue)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        // Perform GET request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Validate HTTP status
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "InvalidResponse", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        // Decode response
        let decoded = try JSONDecoder().decode(ResponseData.self, from: data)
        return decoded
    }
}
