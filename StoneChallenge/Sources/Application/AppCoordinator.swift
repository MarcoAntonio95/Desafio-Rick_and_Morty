//
//  AppCoordinator.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//


import Foundation
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showCharactersFlow()
}

class AppCoordinator: AppCoordinatorProtocol {
    var finishWithDataDelegate: CoordinatorFinishWithDataDelegate?
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .root }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showCharactersFlow()
    }
        
    internal func showCharactersFlow() {
        let charactersFlowCoordinator = CharactersFlowCoordinator.init(navigationController)
        childCoordinators.append(charactersFlowCoordinator)
        charactersFlowCoordinator.start()
    }
    
}

