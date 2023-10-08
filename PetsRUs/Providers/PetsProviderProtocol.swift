//
//  PetsProviderProtocol.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation

protocol PetsProviderProtocol {
    typealias OnAddComplete = () -> Void
    
    var petsInfo: [PetsModel]? { get }
    var petsInfoPublisher: Published<[PetsModel]?>.Publisher { get }
    
    var error: Error? { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    func getPetsInfo() async
    func addPet(petInfo: PetsModel, onAddComplete: @escaping OnAddComplete) async
    func clear() async
}
