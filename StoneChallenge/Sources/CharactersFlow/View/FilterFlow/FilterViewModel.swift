//
//  FilterViewModel.swift
//  StoneChallenge
//
//  Created by Marco Antonio on 27/12/21.
//

import Foundation

class FilterViewModel {
    public static let sharedInstance = FilterViewModel()
    
    func changeFilter(_ name: String = "", _ status: String = ""){
        RickMortyAPI.sharedInstance.resetCurrentPage()
        RickMortyAPI.sharedInstance.setNameAndStatusFilter(name: name, status: status)
        RickMortyAPI.sharedInstance.fetchCharacters()
    }
}
