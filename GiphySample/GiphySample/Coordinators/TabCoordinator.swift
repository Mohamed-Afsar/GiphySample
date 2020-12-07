//
//  TabCoordinator.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
}

final class TabCoordinator: TabCoordinatorProtocol {
    var tabBarController: UITabBarController
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .tab }
        
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        tabBarController = .init()
        _updateStyle(tabBarController: tabBarController)
    }
    
    func start() {
        let pages: [TabBarPage] = [.feed, .favourites].sorted { $0.orderNumber() < $1.orderNumber() }
        let coordinators: [Coordinator] = pages.map {
            let coordinator = _getCoordinator($0)
            coordinator.finishDelegate = self
            coordinator.start()
            self.childCoordinators.append(coordinator)
            return coordinator
        }
        let controllers: [UINavigationController] = coordinators.map { $0.navigationController }
        _prepareTabBarController(withTabControllers: controllers)
    }
}

extension TabCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0.type == childCoordinator.type })
    }
}

// MARK: Helper Functions
private extension TabCoordinator {
    
    func _updateStyle(tabBarController: UITabBarController) {
        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .white
    }
    
    func _getCoordinator(_ page: TabBarPage) -> Coordinator {
        let navController = UINavigationController()
        switch page {
        case .feed:
            return FeedCoordinator(navigationController: navController, tabBarPage: page)
            
        case .favourites:
            return FavouritesCoordinator(navigationController: navController, tabBarPage: page)
        }
    }
    
    func _prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: false)
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }
}
