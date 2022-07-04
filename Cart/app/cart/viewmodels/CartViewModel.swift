//
//  CartViewModel.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import Foundation

class CartViewModel {
    enum State {
        case loading
        case error
        case products
    }
    
    var didUpdateState: ((State) -> Void)?
    var didUpdateTotal: (() -> Void)?
    
    private let cartService: CartService
    private let currencyFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    private var products = [ProductModel]()
    private var countLookup = [Int: Int]()
    private (set) var state = State.loading {
        didSet {
            didUpdateState?(state)
        }
    }
    
    init(cartService: CartService) {
        self.cartService = cartService
    }
    
    //MARK: Data
    func fetch() {
        state = .loading
        cartService.fetchCart { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.products = response.products
                    self.state = .products
                    self.didUpdateTotal?()
                case .failure(_):
                    self.state = .error
                }
            }
        }
    }
    
    func update(count: Int, index: Int) {
        let identifier = products[index].identifier
        countLookup[identifier] = count
        didUpdateTotal?()
    }
}

//MARK: - View Models
extension CartViewModel {
    func productViewModel(index: Int) -> ProductTableViewCellModel {
        let product = products[index]
        let price = NSNumber(value: Double(product.price) ?? 0.0)
        return ProductTableViewCellModel(
            name: product.name,
            count: countLookup[product.identifier] ?? 0,
            price: currencyFormatter.string(from: price) ?? ""
        )
    }
    
    func totalViewModel() -> CartTotalViewModel {
        let total = products.reduce(0.0) { partialResult, product in
            let identifier = product.identifier
            let count = Double(countLookup[identifier] ?? 0)
            let price = Double(product.price) ?? 0.0
            return partialResult + (price * count)
        }
        let price = NSNumber(value: total)
        return CartTotalViewModel(amount: currencyFormatter.string(from: price) ?? "")
    }
}

//MARK: - Table
extension CartViewModel {
    var rows: Int {
        return products.count
    }
}
