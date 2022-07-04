//
//  AppCoordinator.swift
//  Cart
//
//  Created by Victor Noel Barrera on 7/4/22.
//

import UIKit

class BaseCoordinator {
    private (set) var childCoordinators = [BaseCoordinator]()
    private (set) var superCoordinator: BaseCoordinator?
    let identifier = UUID().uuidString
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {}
    
    func addChild(coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
        coordinator.superCoordinator = self
    }
    
    func removeChild(coordinator: BaseCoordinator) {
        childCoordinators.removeAll { (child) -> Bool in
            return child.identifier == coordinator.identifier
        }
        coordinator.superCoordinator = nil
    }
    
    func removeFromSuperCoordinator() {
        superCoordinator?.removeChild(coordinator: self)
    }
}

class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        let viewModel = CartViewModel(cartService: APICartService())
        super.init(rootViewController: CartViewController(viewModel: viewModel))
    }
    
    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
