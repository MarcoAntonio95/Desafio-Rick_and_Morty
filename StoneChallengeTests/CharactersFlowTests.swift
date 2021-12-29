//
//  CharactersFlowTests.swift
//  StoneChallengeTests
//
//  Created by Marco Antonio on 29/12/21.
//

import XCTest
import Foundation
import RxSwift
import RxCocoa
import Alamofire
@testable import StoneChallenge

class CharactersFlowTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testNetworkReachability() {
        XCTAssertTrue(NetworkReachabilityManager()!.isReachable,"The tested device doesn't have network connection")
    }
    
    func testFetchAllCharacters(){
        RickMortyAPI.sharedInstance.fetchCharacters()
        
        let expectation = XCTestExpectation(description: "Test fetch all characters from API")
        RickMortyAPI.sharedInstance.getCurrentCharacters().asObserver().subscribe(
            onNext: { characters in
                if(characters.count > 0){
                    expectation.fulfill()
                }
            }).disposed(by: self.disposeBag)
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testFetchCharactersWithFilter(){
        RickMortyAPI.sharedInstance.setNameFilter(name: "Rick")
        RickMortyAPI.sharedInstance.setStatusFilter(status: "Dead")
        RickMortyAPI.sharedInstance.fetchCharacters()
        
        let expectation = XCTestExpectation(description: "Test fetch characters with filter from API")
        RickMortyAPI.sharedInstance.getCurrentCharacters().asObserver().subscribe(
            onNext: { characters in
                if(characters.count > 0){
                    expectation.fulfill()
                }
            }).disposed(by: self.disposeBag)
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testFetchCharactersFromOtherPage(){
        let selectedPage = 3
        
        for _ in 1...selectedPage{
            RickMortyAPI.sharedInstance.nextPage()
        }
        
        RickMortyAPI.sharedInstance.fetchCharacters()
        
        let expectation = XCTestExpectation(description: "Test fetch characters with filter from API")
        RickMortyAPI.sharedInstance.getCurrentCharacters().asObserver().subscribe(
            onNext: { characters in
                if(characters.count > 0){
                    expectation.fulfill()
                }
            }).disposed(by: self.disposeBag)
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testCharacterImageDownload(){
        let exampleImgUrl = "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        
        let expectation = XCTestExpectation(description: "Test image download from character")
        
        AF.download(exampleImgUrl).response { response in
            switch response.result {
            case .success(_):
                expectation.fulfill()
                break
            case .failure(let error):
                XCTAssertNotNil(error,error.localizedDescription)
                break
            }
        }
        wait(for: [expectation], timeout: 15.0)
    }
}
