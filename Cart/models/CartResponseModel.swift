//
//  CartResponseModel.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import Foundation

struct CartResponseModel {
    let products: [ProductModel]
}

extension CartResponseModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        products = try container.decode([ProductModel].self)
    }
}
