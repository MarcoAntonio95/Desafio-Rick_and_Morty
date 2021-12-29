//
//  CharactersViewModel.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//


import Foundation
import RxSwift
import RxCocoa

final class CharactersViewModel {
    
    // MARK: Varbles & Constants
    private let coordinator: CharactersFlowCoordinator
    private let disposeBag = DisposeBag()
    
    // MARK: Initialization
    init(coordinator: CharactersFlowCoordinator) {
        self.coordinator = coordinator
        RickMortyAPI.sharedInstance.fetchCharacters()
    }

    let currentCharacters = RickMortyAPI.sharedInstance.getCurrentCharacters()
    
    // MARK: Public functions
    func startDetailsFlow(currentCharacter: Any){
        self.coordinator.finishWithData(data: currentCharacter)
    }
    
    func nextPage(){
        RickMortyAPI.sharedInstance.nextPage()
    }
    
    func downloadCharacterImage(imageUrl: String) -> Observable<Data> {
        return RickMortyAPI.sharedInstance.downloadCharacterImage(imageUrl: imageUrl)
    }
         
    func showFilterView(currentView: UIViewController){
        let filterViewModel = FilterViewModel()
        let filterViewController = FilterViewController(viewModel: filterViewModel)
        filterViewController.modalPresentationStyle = .overFullScreen
        currentView.present(filterViewController, animated: true, completion: nil)
    }
}
