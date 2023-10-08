//
//  MockInfoStore.swift
//  PetsRUsTests
//
//  Created by John Dumais on 10/7/23.
//

import Foundation
@testable import PetsRUs

class MockinfoStore: InfoStoreProtocol {
    func setPetsInfo(petsInfo: [PetsModel]) async -> Result<Bool, Error> {
        .success(true)
    }
    
    func getPetsInfo() async -> Result<[PetsModel], Error> {
        .success([])
    }
    
//    @Published var petsInfo: [PetsModel]?
//    var petsInfoPublisher: Published<[PetsModel]?>.Publisher { $petsInfo }
//
//    @Published var error: Error?
//    var errorPublisher: Published<Error?>.Publisher { $error }
//
//    var getShouldError = false
//    var setShouldError = false
//
//    func getPetsInfo() async {
//        if getShouldError {
//            error = "Try to imagine all life as you know it stopping instantaneously and every molecule in your body exploding at the speed of light."
//            return
//        }
//
//        petsInfo = [PetsModel(name: "Gracie", age: 14, breed: "Eskimo", lastVetVisit: Date(), trackingChipId: "85")]
//    }
//
//    func setPetsInfo(petsInfo: [PetsModel], onSetComplete: @escaping OnSetComplete) async {
//        if setShouldError {
//            error = "Have you ever inhabited a place in which all hope is lost?"
//            return
//        }
//
//        onSetComplete()
//    }
}
