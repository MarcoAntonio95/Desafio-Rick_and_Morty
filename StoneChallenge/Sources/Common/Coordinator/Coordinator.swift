//
//  Coordinator.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var finishWithDataDelegate: CoordinatorFinishWithDataDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var type: CoordinatorType { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
    func finish()
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func finishWithData(data: Any){
        finishWithDataDelegate?.coordinatorDidFinishWithData(data: data, childCoordinator: self)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

protocol CoordinatorFinishWithDataDelegate: AnyObject {
    func coordinatorDidFinishWithData(data: Any,childCoordinator: Coordinator)
}

protocol CoordinatorTitleDelegate: AnyObject {
    func setNavigationTitle(title: String)
}

enum CoordinatorType {
    case root, characters, details
}
