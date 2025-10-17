//
//  SearchLocationResponse.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 17/10/25.
//

import Foundation

struct SearchLocationResponse: Decodable {
    let placeId: String?
    let mainText: String?
    let secondaryText: String?
    var displayText: String {
        [mainText, secondaryText].compactMap { $0 }.joined(separator: ", ")
    }
    
    enum CodingKeys: String, CodingKey {
        case placeId = "placeId"
        case mainText = "mainText"
        case secondaryText = "secondaryText"
    }
}
