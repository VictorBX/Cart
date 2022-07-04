//
//  CartViewModelTests.swift
//  CartTests
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import XCTest
@testable import Cart

class CartViewModelTests: XCTestCase {
    //MARK: - Mock Data
    private let currencyFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    struct MockCartService: CartService {
        var shouldReturnError = false
        
        func fetchCart(completion: @escaping (Result<CartResponseModel, CartError>) -> Void) {
            if shouldReturnError {
                completion(.failure(.noData))
            } else {
                let response = CartResponseModel(products: [
                    ProductModel(identifier: 1, name: "Test1", price: "5.00"),
                    ProductModel(identifier: 2, name: "Test2", price: "6.99"),
                    ProductModel(identifier: 3, name: "Test3", price: "20.50")
                ])
                completion(.success(response))
            }
        }
    }

    //MARK: - State
    func testState_success() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        
        // when
        viewModel.didUpdateState = { [weak self] state in
            guard self != nil else {
                XCTFail()
                return
            }
            if state == .loading {
                return
            }
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(CartViewModel.State.products, viewModel.state)
    }
    
    func testState_error() throws {
        // given
        let expectation = XCTestExpectation()
        var cartService = MockCartService()
        cartService.shouldReturnError = true
        let viewModel = CartViewModel(cartService: cartService)
        
        // when
        viewModel.didUpdateState = { [weak self] state in
            guard self != nil else {
                XCTFail()
                return
            }
            if state == .loading {
                return
            }
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(CartViewModel.State.error, viewModel.state)
    }
    
    func testState_triggeredCallback() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        var finalState = CartViewModel.State.loading
        
        // when
        viewModel.didUpdateState = { [weak self] state in
            guard self != nil else {
                XCTFail()
                return
            }
            if state == .loading {
                return
            }
            finalState = state
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(CartViewModel.State.products, finalState)
    }
    
    //MARK: - Rows
    func testRows() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        
        // when
        viewModel.didUpdateState = { [weak self] state in
            guard self != nil else {
                XCTFail()
                return
            }
            if state == .loading {
                return
            }
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(3, viewModel.rows)
    }
    
    //MARK: - Total
    func testTotal_onFetch_triggeredCallback() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        var wasTriggered = false
        
        // when
        viewModel.didUpdateTotal = { [weak self] in
            guard self != nil else {
                XCTFail()
                return
            }
            wasTriggered = true
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(wasTriggered)
    }
    
    func testTotal_onUpdate_triggeredCallback() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        var shouldSkip = true
        var wasTriggered = false
        
        // when
        viewModel.didUpdateTotal = { [weak self] in
            guard self != nil else {
                XCTFail()
                return
            }
            guard !shouldSkip else {
                shouldSkip = false
                viewModel.update(count: 1, index: 0)
                return
            }
            wasTriggered = true
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(wasTriggered)
    }
    
    //MARK: - Child View Models
    func testVM_productViewModel() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        var productViewModel: ProductTableViewCellModel?
        
        // when
        viewModel.didUpdateState = { [weak self] state in
            guard self != nil else {
                XCTFail()
                return
            }
            if state == .loading {
                return
            }
            productViewModel = viewModel.productViewModel(index: 0)
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        guard let productViewModel = productViewModel else {
            XCTFail("productViewModel should exist")
            return
        }
        XCTAssertEqual("Test1", productViewModel.name)
        XCTAssertEqual(0, productViewModel.count)
        let price = currencyFormatter.string(from: NSNumber(value: 5.00))
        XCTAssertEqual(price, productViewModel.price)
    }
    
    func testVM_totalViewModel() throws {
        // given
        let expectation = XCTestExpectation()
        let cartService = MockCartService()
        let viewModel = CartViewModel(cartService: cartService)
        var totalViewModel: CartTotalViewModel?
        
        // when
        viewModel.didUpdateState = { [weak self] state in
            guard self != nil else {
                XCTFail()
                return
            }
            if state == .loading {
                return
            }
            viewModel.update(count: 1, index: 0)
            viewModel.update(count: 1, index: 1)
            totalViewModel = viewModel.totalViewModel()
            expectation.fulfill()
        }
        viewModel.fetch()
        
        // then
        wait(for: [expectation], timeout: 1.0)
        guard let totalViewModel = totalViewModel else {
            XCTFail("totalViewModel should exist")
            return
        }
        let price = currencyFormatter.string(from: NSNumber(value: 11.99))
        XCTAssertEqual(price, totalViewModel.amount)
    }
}
