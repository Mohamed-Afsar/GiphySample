//
//  FeedCoordinator.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit
  
protocol FeedCoordinatorProtocol: Coordinator {
    var tabBarPage: TabBarPage? { get set }
}

final class FeedCoordinator: FeedCoordinatorProtocol {
    var tabBarPage: TabBarPage?
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .favourites }
    
    convenience init(navigationController: UINavigationController, tabBarPage: TabBarPage) {
        self.init(navigationController)
        self.tabBarPage = tabBarPage
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.setNavigationBarHidden(false, animated: false)
        if let page = tabBarPage {
            navigationController.tabBarItem = UITabBarItem.init(title: page.titleValue(),
                                                         image: page.icon(),
                                                         tag: page.orderNumber())
        }
        let feedVC: FeedViewController = .gs_Instantiate()
        navigationController.pushViewController(feedVC, animated: false)
    }
}
