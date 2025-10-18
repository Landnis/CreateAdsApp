//
//  NetworkManager.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 17/10/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    private let baseUrl = "https://oapaiqtgkr6wfbum252tswprwa0ausnb.lambda-url.eu-central-1.on.aws"
    private let queryParameter = "input"
    private let cache = NSCache<NSString, NSData>()
    
    func request<ResponseData: Decodable>(
        searchValue: String,
        responseType: ResponseData.Type
    ) async throws -> ResponseData {
        
        // ✅ normalized key to avoid case-sensitive duplicates
        let cacheKey = NSString(string: searchValue.lowercased())
        
        // ✅ 1. Check cache first
        if let cachedData = cache.object(forKey: cacheKey) {
            let decoded = try JSONDecoder().decode(ResponseData.self, from: cachedData as Data)
            return decoded
        }
        
        // ✅ 2. Build URL
        guard var components = URLComponents(string: baseUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: queryParameter, value: searchValue)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        // ✅ 3. Perform GET request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // ✅ 4. Validate HTTP status
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "InvalidResponse", code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        // ✅ 5. Cache successful response before returning it
        cache.setObject(data as NSData, forKey: cacheKey)
        
        // ✅ 6. Decode response
        let decoded = try JSONDecoder().decode(ResponseData.self, from: data)
        return decoded
    }
    
    func encodeToJSON<CodableObject: Codable>(_ object: CodableObject) throws -> String {
        
        // Encode the object
        let jsonData = try JSONEncoder().encode(object)
        
        // Validate the String jsonData
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "JSONEncodingError", code: -1)
        }
        
        return jsonString
    }
}
