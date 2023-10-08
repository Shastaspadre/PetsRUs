//
//  PetsProvider.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation
import Combine

class PetsProvider: PetsProviderProtocol {
    @Published var petsInfo: [PetsModel]?
    var petsInfoPublisher: Published<[PetsModel]?>.Publisher { $petsInfo }
    
    @Published var error: Error?
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private let infoStore: InfoStoreProtocol
    
    init(infoStore: InfoStoreProtocol) {
        self.infoStore = infoStore
    }
    
    func getPetsInfo() async {
        do {
            petsInfo = try await infoStore.getPetsInfo().get()
        } catch {
            self.error = error
        }
    }
    
    func addPet(petInfo: PetsModel, onAddComplete: @escaping OnAddComplete) async {
        do {
            var persistedPets = try await infoStore.getPetsInfo().get()
            
            if infoStoreContains(petInfo: petInfo, inPersistedPets: persistedPets) {
                onAddComplete(false)
                return
            }
            
            persistedPets.append(petInfo)
            await persistPets(petsInfo: persistedPets, onAddComplete: onAddComplete)
        } catch {
            self.error = error
        }
    }
    
    private func infoStoreContains(petInfo: PetsModel, inPersistedPets persistedPets: [PetsModel]) -> Bool {
        persistedPets.contains { persistedPet in
            persistedPet == petInfo
        }
    }
    
    private func persistPets(petsInfo: [PetsModel], onAddComplete: @escaping OnAddComplete) async {
        _ = await infoStore.setPetsInfo(petsInfo: petsInfo)
            .map { petAdded in
                onAddComplete(petAdded)
            }
            .mapError { (error) -> Error in
                self.error = error
                return error
            }
    }
    
    func clear() async {
        await persistPets(petsInfo: [], onAddComplete: { _ in })
    }
}
