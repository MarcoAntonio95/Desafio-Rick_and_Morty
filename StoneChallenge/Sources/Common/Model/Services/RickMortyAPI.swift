//
//  RickMortyAPI.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class RickMortyAPI {
    // MARK: Varbles & Constants
    public static let sharedInstance = RickMortyAPI()
    private let disposeBag = DisposeBag()
    private var baseUrl = "https://rickandmortyapi.com/api/character"
    
    private let currentCharacters : PublishSubject<[Character]> = PublishSubject()
    private var characters : [Character] = []
    private var numberOfPages = 1
    private var currentPage = 1
    private var nameFilter = ""
    private var statusFilter = ""
    
    // MARK: Public functions
    func setNameFilter(name: String){
        self.nameFilter = name
    }
    
    func setStatusFilter(status: String){
        self.statusFilter = status
    }
    func setNameAndStatusFilter(name: String,status: String){
        self.nameFilter = name
        self.statusFilter = status
    }
    
    func resetCurrentPage(){
        self.currentPage = 1
        self.characters = []
        self.currentCharacters.onNext(self.characters)
    }
    
    func nextPage(){
        if self.currentPage <= self.numberOfPages {
            self.currentPage += 1
            if(NetworkReachabilityManager()!.isReachable){
                self.fetchCharactersOnline()
            }
        }
    }
    
    func getCurrentCharacters() -> PublishSubject<[Character]>{
        return self.currentCharacters
    }
            
    func fetchCharacters(){
        if(NetworkReachabilityManager()!.isReachable){
            self.fetchCharactersOnline()
        } else {
            self.fetchCharactersOffline()
        }
    }
    
    func downloadCharacterImage(imageUrl:String) -> Observable<Data> {
        return Observable.create { imgObserver -> Disposable in
            AF.download(imageUrl).response { response in
                switch response.result {
                case .success(let value):
                    guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: value?.relativePath ?? "")) else {return}
                    imgObserver.onNext(imageData)
                    break
                case .failure(let error):
                    imgObserver.onError(error)
                    break
                }
                
            }
            return Disposables.create {}
            
        }
    }
    
    fileprivate func fetchCharactersOnline() {
               
        var charactersUrl = self.baseUrl
        
        charactersUrl = charactersUrl+"/?page=\(self.currentPage)"
        
        if (!self.nameFilter.isEmpty && !self.statusFilter.isEmpty){
            charactersUrl = charactersUrl + "&name=\(self.nameFilter)&status=\(self.statusFilter)"
        } else if(!self.nameFilter.isEmpty){
            charactersUrl = charactersUrl + "&name=\(self.nameFilter)"
        } else if (!self.statusFilter.isEmpty){
            charactersUrl = charactersUrl + "&status=\(self.statusFilter)"
        }

        AF.request(charactersUrl, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    var charactersList = [Character]()
                    let json = JSON(value)
                    let charactersJson = json["results"]
                    self.numberOfPages = json["info"]["pages"].intValue
                    self.downloadJson()
                    for i in 0...charactersJson.count-1 {
                        let characterAux = self.createCharacterByJson(charactersJson: charactersJson[i])
                        
                        charactersList.append(characterAux)
                    }
                    
                    self.characters = self.characters+charactersList
                    
                    self.currentCharacters.onNext(self.characters)
                case .failure(_):
                    break
            }
        }
    }
    
    fileprivate func fetchCharactersOffline(){
        let jsonPath = UserDefaults.standard.string(forKey: "charactersURL") ?? ""
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {return}
        guard let json = try? JSON(data: jsonData) else {return}
        let charactersJson = json["results"]
        var charactersList = [Character]()
        
        for i in 0...charactersJson.count-1 {
            
            let characterAux = self.createCharacterByJson(charactersJson: charactersJson[i])
            
            if (self.nameFilter.isEmpty && statusFilter.isEmpty){
                charactersList.append(characterAux)
            } else if (!nameFilter.isEmpty && !statusFilter.isEmpty && nameFilter == characterAux.name && statusFilter == characterAux.status){
                charactersList.append(characterAux)
            } else if (!nameFilter.isEmpty && nameFilter == characterAux.name){
                charactersList.append(characterAux)
            } else if (!statusFilter.isEmpty && statusFilter == characterAux.status){
                charactersList.append(characterAux)
            }
        }
        self.currentCharacters.onNext(charactersList)
    }
    
    fileprivate  func downloadJson(){
        let jsonPath = UserDefaults.standard.string(forKey: "charactersURL") ?? ""
    
        if jsonPath.isEmpty {
            var currentJSON = JSON()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("characters.JSON")
            
            UserDefaults.standard.set(fileURL.relativePath, forKey: "charactersURL")
            
            for page in 1...self.numberOfPages {
                let pageUrl = baseUrl+"/?page=\(page)"
                AF.download(pageUrl).response { response in
                    if response.error == nil, let jsonPath = response.fileURL?.path {
                        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {return}
                        guard let json = try? JSON(data: jsonData) else {return}
                        try? currentJSON.merge(with: json)
                        
                        do {
                           try currentJSON.rawData().write(to: fileURL)
                        } catch let error as NSError {
                            print("Couldn't write to file: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
}

extension RickMortyAPI {
    fileprivate func createCharacterByJson(charactersJson: JSON) -> Character{
        var characterAux = Character()
        characterAux.id = charactersJson["id"].stringValue
        characterAux.name = charactersJson["name"].stringValue
        characterAux.status = charactersJson["status"].stringValue
        characterAux.species = charactersJson["species"].stringValue
        characterAux.type = charactersJson["type"].stringValue
        characterAux.gender = charactersJson["gender"].stringValue
        characterAux.imageUrl = charactersJson["image"].stringValue
        return characterAux
    }
}
