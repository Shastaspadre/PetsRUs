//
//  InfoStore.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation

class InfoStore: InfoStoreProtocol {
    @Published private (set) var petsInfo: [PetsModel]?
    var petsInfoPublisher: Published<[PetsModel]?>.Publisher { $petsInfo }
    
    @Published private (set) var error: Error?
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private enum InfoStoreCategory: String {
        case petsInfo
    }
    
    static let shared = InfoStore()
    
    private init() {
        UserDefaults.standard.register(defaults: [
            InfoStoreCategory.petsInfo.rawValue: []
        ])
    }
    
    func getPetsInfo() async {
        guard let petsTextInfo = UserDefaults.standard.string(forKey: InfoStoreCategory.petsInfo.rawValue) else {
            petsInfo = []
            return
        }
        
        guard let petsData = petsTextInfo.data(using: .utf8) else {
            error = NSLocalizedString("Error encoding pets info from data provider.", comment: "")
            return
        }
        
        guard let pets = try? JSONDecoder().decode([PetsModel].self, from: petsData) else {
            error = NSLocalizedString("Error decoding pets info from data provider.", comment: "")
            return
        }
        
        petsInfo = pets
    }
    
    func setPetsInfo(petsInfo: [PetsModel], onSetComplete: @escaping OnSetComplete = {}) async {
        guard let encodedPets = try? JSONEncoder().encode(petsInfo) else {
            error = NSLocalizedString("Error encoding pets info for data storage.", comment: "")
            return
        }
        
        guard let encodedText = String(data: encodedPets, encoding: .utf8) else {
            error = NSLocalizedString("Error serializing pets info for data storage.", comment: "")
            return
        }
        
        UserDefaults.standard.set(encodedText, forKey: InfoStoreCategory.petsInfo.rawValue)
        
        onSetComplete()
    }
}
