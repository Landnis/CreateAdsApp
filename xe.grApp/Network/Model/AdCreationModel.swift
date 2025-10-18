//
//  AdCreationModel.swift
//  xe.grApp
//
//  Created by Konstantinos Stergiannis on 18/10/25.
//

import Foundation

struct AdCreationModel: Codable {
    let location: String
    let title: String
    let price: String?
    let description: String?
}
