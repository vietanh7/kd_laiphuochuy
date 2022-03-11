//
//  ProductListResponse.swift
//  Klikdokter
//
//  Created by Huy Lai on 3/10/22.
//

class Product: Codable {
    var id: Int
    var sku: String
    var productName: String
    var qty: Int
    var price: Int
    var unit: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case productName = "product_name"
        case qty
        case price
        case unit
    }
}
