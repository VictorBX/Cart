//
//  CartService.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import Foundation

enum CartError: Error {
    case invalidUrl
    case noData
    case failedDecoding(Error)
    case failedFetching(Error)
}

protocol CartService {
    func fetchCart(completion: @escaping (Result<CartResponseModel, CartError>) -> Void)
}

class APICartService: CartService {
    private enum Endpoint : String {
        case products = "https://ls-ios-products.herokuapp.com/"
    }
    
    private let session = URLSession.shared
    
    func fetchCart(completion: @escaping (Result<CartResponseModel, CartError>) -> Void) {
        guard let url = URL(string: Endpoint.products.rawValue) else {
            completion(.failure(.invalidUrl))
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.failedFetching(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let response = try JSONDecoder().decode(CartResponseModel.self, from: data)
                completion(.success(response))
            } catch let decodingError {
                completion(.failure(.failedDecoding(decodingError)))
            }
        }.resume()
    }
}
