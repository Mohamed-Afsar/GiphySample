//
//  FavouritesCoordinator.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit
  
protocol FavouritesCoordinatorProtocol: Coordinator {
    var tabBarPage: TabBarPage? { get set }
}

final class FavouritesCoordinator: FavouritesCoordinatorProtocol {
    var tabBarPage: TabBarPage?
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .feed }
    
    convenience init(navigationController: UINavigationController, tabBarPage: TabBarPage) {
        self.init(navigationController)
        self.tabBarPage = tabBarPage
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.setNavigationBarHidden(false, animated: false)
        let title: String
        if let page = tabBarPage {
            navigationController.tabBarItem = UITabBarItem.init(title: page.titleValue(),
                                                         image: page.icon(),
                                                         tag: page.orderNumber())
            title = page.titleValue()
        }
        else {
            title = "Favourites"
        }
        let viewModel = FavouritesViewModel(interactor: FavouritesViewInteractor(), title: title)
        let favouriteVC: FavouritesViewController = .gs_Instantiate()
        favouriteVC.viewModel = viewModel
        navigationController.pushViewController(favouriteVC, animated: false)
    }
}
