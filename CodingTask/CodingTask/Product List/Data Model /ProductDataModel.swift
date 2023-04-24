//
//  ProductDataModel.swift
//  CodingTask
//
//  Created by Suman Chatterjee on 23/04/23.
//

import Foundation

struct ProductListResult: Codable {
    let products: [Product]?
    let total: Int?
    
    enum CodingKeys: String, CodingKey {
        case products
        case total
    }
}

// MARK: - Product
struct Product: Codable {
    let proudctId: Int?
    let title, description: String?
    let price: Int?
    let discountPercentage, rating: Double?
    let stock: Int?
    let brand: String?
    let thumbnail: String?
    let images: [String]?
    

    enum CodingKeys: String, CodingKey {
        case proudctId = "id"
        case title
        case description
        case price
        case discountPercentage
        case rating
        case stock
        case brand
        case thumbnail
        case images
    }
}

struct ProductUIModel {
    let title, description: String?
    let imageUrlString: String?
    var isSelected: Bool = false
}
