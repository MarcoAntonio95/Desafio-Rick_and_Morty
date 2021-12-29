//
//  CharacterDetailsCoordinator.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 28/12/21.
//

import Foundation
import UIKit

protocol CharacterDetailsFlowCoordinatorProtocol: Coordinator {
    func startCharacterDetailsViewController()
}

class CharacterDetailsFlowCoordinator: Coordinator, CharacterDetailsFlowCoordinatorProtocol {
    
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
        self.startCharacterDetailsViewController()
    }
    
    // MARK: Internal functions
    internal func startCharacterDetailsViewController() {
        let characterDetailsViewModel = CharacterDetailsViewModel(coordinator: self)
        let detailsVC: CharacterDetailsViewController = .init(viewModel: characterDetailsViewModel)
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    internal func startDetailsWithDataViewController(_ currentCharacter:Character,_ fromCordinator: Coordinator) {
        let detailsViewModel = CharacterDetailsViewModel(coordinator: self)
        let detailsVC: CharacterDetailsViewController = .init(viewModel: detailsViewModel)
        if !(currentCharacter.id?.isEmpty ?? false) {
            detailsVC.currentCharacter = currentCharacter
        }
        fromCordinator.navigationController.pushViewController(detailsVC, animated: true)
    }
    
    // MARK: Deinitialization
    deinit {
        print("CharactersFlowCoordinator deinit")
    }
}
