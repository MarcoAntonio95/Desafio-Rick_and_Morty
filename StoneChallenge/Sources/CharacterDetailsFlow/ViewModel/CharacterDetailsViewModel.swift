//
//  CharacterDetailsViewModel.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 28/12/21.
//

import Foundation
import RxCocoa
import RxSwift

final class CharacterDetailsViewModel {
    
    // MARK: Varbles & Constants
    private let coordinator: CharacterDetailsFlowCoordinator
    
    // MARK: Initialization
    init(coordinator: CharacterDetailsFlowCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: Public functions
    func downloadCharacterImage(imageUrl: String) -> Observable<Data> {
        return RickMortyAPI.sharedInstance.downloadCharacterImage(imageUrl: imageUrl)
    }
    
    func returnToCharacters(){
        self.coordinator.navigationController.popViewController(animated: true)
    }
    
    // MARK: Deinitialization
    deinit {
        print("DetailsFlowCoordinator deinit")
    }
}
