//
//  Coordinator.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 04/12/20.
//

import UIKit

// MARK: Definition
protocol Coordinator: class {
    /// Can be conformed to know child coordinators' completion.
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    // Each coordinator should have one navigation controller assigned to it.
    var navigationController: UINavigationController { get set }
    
    /// Array to keep tracking of all child coordinators. Most of the time this array will contain only one child coordinator.
    var childCoordinators: [Coordinator] { get set }
    
    /// Defines the flow type.
    var type: CoordinatorType { get }
    
    /// A place to put logic to start the flow.
    func start()
    
    /// A place to put logic to finish the flow, to clean all children coordinators, and to notify the parent that this coordinator is ready to be deallocated.
    func finish()
    
    /// Forcing 'UINavigationController' injection.
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

// MARK: Supporting Types
/// Delegate protocol helping parent Coordinator know when its child is ready to be finished.
protocol CoordinatorFinishDelegate: class {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

/// Using this enum we can define what type of flow we can use in-app.
enum CoordinatorType {
    case app, tab, feed, favourites
}
