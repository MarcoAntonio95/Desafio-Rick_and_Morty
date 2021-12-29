//
//  CharactersCoordinator.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import Foundation
import UIKit

protocol CharactersFlowCoordinatorProtocol: Coordinator {
    func startCharactersViewController()
}

class CharactersFlowCoordinator: Coordinator, CharactersFlowCoordinatorProtocol {
    
    // MARK: Varbles & Constants
    var finishDelegate: CoordinatorFinishDelegate?
    var finishWithDataDelegate: CoordinatorFinishWithDataDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .characters}
    
    // MARK: Initialization
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Public functions
    func start() {
        self.finishWithDataDelegate = self
        self.startCharactersViewController()
    }
    
    // MARK: Internal functions
    internal func startCharactersViewController() {
        let charactersViewModel = CharactersViewModel(coordinator: self)
        let charactersVC: CharactersViewController = .init(viewModel: charactersViewModel)
        navigationController.pushViewController(charactersVC, animated: true)
    }
    
    internal func startCharacterDetailsViewController(_ character:Any, _ childCoordinator: Coordinator) {
        let detailsFlowCoordinator = CharacterDetailsFlowCoordinator.init(navigationController)
        childCoordinators.append(detailsFlowCoordinator)
        
        if let characterData = character as? Character {
            detailsFlowCoordinator.startDetailsWithDataViewController(characterData, childCoordinator)
        }
    }
    
    // MARK: Deinitialization
    deinit {
        print("CharactersFlowCoordinator deinit")
    }
}


extension CharactersFlowCoordinator: CoordinatorFinishWithDataDelegate {
    func coordinatorDidFinishWithData(data: Any, childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        if childCoordinator.type  == .characters {
            self.startCharacterDetailsViewController(data,childCoordinator)
        }
    }
}
