//
//  AppCoordinator.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit

/// Defines what type of flows can be started from this Coordinator.
protocol AppCoordinatorProtocol: Coordinator {
    func showMainFlow()
}

final class AppCoordinator: AppCoordinatorProtocol {
    var finishDelegate: CoordinatorFinishDelegate? = nil // Since it is the starting point.
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .app }
    
    init(_ navigationController: UINavigationController) {
        navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController = navigationController
    }
    
    func start() {
        showMainFlow()
    }
    
    func showMainFlow() {
        let tabCoordinator: TabCoordinatorProtocol = TabCoordinator(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0.type == childCoordinator.type })
    }
}
