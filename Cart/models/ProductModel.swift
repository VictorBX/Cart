//
//  ProductModel.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import Foundation

struct ProductModel: Decodable {
    let identifier: Int
    let name: String
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case price
    }
}
