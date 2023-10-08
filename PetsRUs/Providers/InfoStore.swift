//
//  InfoStore.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation

class InfoStore: InfoStoreProtocol {
    private enum InfoStoreCategory: String {
        case petsInfo
    }
    
    static let shared = InfoStore()
    
    private init() {
        UserDefaults.standard.register(defaults: [
            InfoStoreCategory.petsInfo.rawValue: []
        ])
    }
    
    func getPetsInfo() async -> Result<[PetsModel], Error> {
        guard let petsTextInfo = UserDefaults.standard.string(forKey: InfoStoreCategory.petsInfo.rawValue) else { return .success([]) }
        guard let petsData = petsTextInfo.data(using: .utf8) else { return .success([]) }
        guard let pets = try? JSONDecoder().decode([PetsModel].self, from: petsData) else { return .success([]) }
        return .success(pets)
    }
    
    func setPetsInfo(petsInfo: [PetsModel]) async -> Result<Bool, Error> {
        guard let encodedPets = try? JSONEncoder().encode(petsInfo) else { return .failure(NSLocalizedString("Error encoding pets info for data storage.", comment: "")) }
        guard let encodedText = String(data: encodedPets, encoding: .utf8) else { return .failure(NSLocalizedString("Error serializing pets info for data storage.", comment: "")) }
        
        UserDefaults.standard.set(encodedText, forKey: InfoStoreCategory.petsInfo.rawValue)
        
        if petsInfo.isEmpty {
            return .success(false)
        }
        
        return .success(true)
    }
}
