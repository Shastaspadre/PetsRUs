//
//  PetsProvider.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation
import Combine

class PetsProvider: PetsProviderProtocol {
    @Published private (set) var petsInfo: [PetsModel]?
    var petsInfoPublisher: Published<[PetsModel]?>.Publisher { $petsInfo }
    
    @Published private (set) var error: Error?
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private let infoStore: InfoStoreProtocol
    
    private var subscriptions = Set<AnyCancellable>()
    
    // TODO: Make these pass through subjects if time permits
    init(infoStore: InfoStoreProtocol) {
        self.infoStore = infoStore
        
        infoStore.errorPublisher
            .sink { error in
                guard let error = error else { return }
                
                self.error = error
            }
            .store(in: &subscriptions)
        
        infoStore.petsInfoPublisher
            .sink { petsInfo in
                self.petsInfo = petsInfo
            }
            .store(in: &subscriptions)
    }
    
    func getPetsInfo() async {
        await infoStore.getPetsInfo()
    }
    
    func addPet(petInfo: PetsModel, onAddComplete: @escaping OnAddComplete) async {
        guard infoStoreDoesNotContain(petInfo: petInfo) else { return }
        
        if var persistedPets = infoStore.petsInfo {
            persistedPets.append(petInfo)
            await infoStore.setPetsInfo(petsInfo: persistedPets, onSetComplete: onAddComplete)
        } else {
            await infoStore.setPetsInfo(petsInfo: [petInfo], onSetComplete: onAddComplete)
        }
    }
    
    private func infoStoreDoesNotContain(petInfo: PetsModel) -> Bool {
        !infoStoreContains(petInfo: petInfo)
    }
    
    private func infoStoreContains(petInfo: PetsModel) -> Bool {
        guard let persistedPetInfo = infoStore.petsInfo else { return false }
        guard persistedPetInfo.isNotEmpty else { return false}
        
        return persistedPetInfo.contains { $0 == petInfo }
    }
    
    func clear() async {
        await infoStore.setPetsInfo(petsInfo: [], onSetComplete: {})
    }
}
