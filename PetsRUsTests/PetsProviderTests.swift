//
//  PetsProviderTests.swift
//  PetsRUsTests
//
//  Created by John Dumais on 10/7/23.
//

import XCTest
@testable import PetsRUs
import Combine

class PetsProviderTests: XCTestCase {
//    private var subscriptions = Set<AnyCancellable>()
//
//    override func setUpWithError() throws {
//        clearSubscriptions()
//        clearInfoStore()
//    }
//    
//    private func clearSubscriptions() {
//        subscriptions.forEach { subscription in
//            subscription.cancel()
//        }
//        
//        subscriptions.removeAll()
//    }
//    
//    private func clearInfoStore() {
//        let sync = DispatchSemaphore(value: 0)
//        
//        Task {
//            await InfoStore.shared.setPetsInfo(petsInfo: []) {
//                sync.signal()
//            }
//        }
//        
//        sync.wait()
//    }
//
//    override func tearDownWithError() throws {
//        clearSubscriptions()
//        clearInfoStore()
//    }
//
//    func testGettingPetsFromEmptyPetsprovider() {
//        let sync = DispatchSemaphore(value: 0)
//        
//        let petsProvider = PetsProvider(infoStore: InfoStore.shared)
//        
//        petsProvider.petsInfoPublisher
//            .dropFirst()
//            .sink { petsInfo in
//                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
//                
//                XCTAssertTrue(petsInfo.isEmpty)
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        petsProvider.errorPublisher
//            .sink { error in
//                guard let error = error else { return }
//                
//                XCTFail("Error: \(error.localizedDescription)")
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        Task {
//            await petsProvider.getPetsInfo()
//        }
//        
//        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
//            XCTFail("Timed out")
//        }
//    }
//    
//    func testGetting1Pet() {
//        let sync = DispatchSemaphore(value: 0)
//        
//        let petsProvider = PetsProvider(infoStore: InfoStore.shared)
//        
//        let name = "Gracie"
//        let age = 14
//        let breed = "Eskimo"
//        let date = Date()
//        let trackingChipId = "85"
//        
//        petsProvider.petsInfoPublisher
//            .dropFirst()
//            .sink { petsInfo in
//                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
//                
//                XCTAssertTrue(petsInfo.isNotEmpty)
//                XCTAssertEqual(petsInfo.count, 1)
//                
//                XCTAssertEqual(petsInfo[0].name, name)
//                XCTAssertEqual(petsInfo[0].age, age)
//                XCTAssertEqual(petsInfo[0].breed, breed)
//                XCTAssertEqual(petsInfo[0].lastVetVisit, date)
//                XCTAssertEqual(petsInfo[0].trackingChipId, trackingChipId)
//                
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        petsProvider.errorPublisher
//            .sink { error in
//                guard let error = error else { return }
//                
//                XCTFail("Error: \(error.localizedDescription)")
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        
//        Task {
//            await petsProvider.addPet(
//                petInfo: PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId),
//                onAddComplete: { self.getPetsInfo(petsProvider: petsProvider) }
//            )
//        }
//        
//        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
//            XCTFail("Timed out")
//        }
//    }
//    
//    private func getPetsInfo(petsProvider: PetsProviderProtocol) {
//        Task {
//            await petsProvider.getPetsInfo()
//        }
//    }
//    
//    func testSettingTheSamePet() {
//        let sync = DispatchSemaphore(value: 0)
//        
//        let petsProvider = PetsProvider(infoStore: InfoStore.shared)
//        
//        let name = "Gracie"
//        let age = 14
//        let breed = "Eskimo"
//        let date = Date()
//        let trackingChipId = "85"
//        
//        petsProvider.petsInfoPublisher
//            .dropFirst()
//            .sink { petsInfo in
//                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
//                
//                XCTAssertTrue(petsInfo.isNotEmpty)
//                XCTAssertEqual(petsInfo.count, 1)
//                
//                XCTAssertEqual(petsInfo[0].name, name)
//                XCTAssertEqual(petsInfo[0].age, age)
//                XCTAssertEqual(petsInfo[0].breed, breed)
//                XCTAssertEqual(petsInfo[0].lastVetVisit, date)
//                XCTAssertEqual(petsInfo[0].trackingChipId, trackingChipId)
//                
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        petsProvider.errorPublisher
//            .sink { error in
//                guard let error = error else { return }
//                
//                XCTFail("Error: \(error.localizedDescription)")
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        
//        Task {
//            await petsProvider.addPet(
//                petInfo: PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId),
//                onAddComplete: {}
//            )
//            
//            await petsProvider.addPet(
//                petInfo: PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId),
//                onAddComplete: { self.getPetsInfo(petsProvider: petsProvider) }
//            )
//        }
//        
//        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
//            XCTFail("Timed out")
//        }
//    }
//    
//    func testSetting2Pets() {
//        let sync = DispatchSemaphore(value: 0)
//        
//        let petsProvider = PetsProvider(infoStore: InfoStore.shared)
//        
//        let name = "Gracie"
//        let age = 14
//        let breed = "Eskimo"
//        let date = Date()
//        let trackingChipId = "85"
//        
//        let name2 = "Shasta"
//        let age2 = 9
//        let breed2 = "Eskimo"
//        let date2 = Date()
//        let trackingChipId2 = "86"
//        
//        petsProvider.petsInfoPublisher
//            .dropFirst()
//            .sink { petsInfo in
//                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
//                
//                print("---> \(petsInfo)")
//                
////                XCTAssertTrue(petsInfo.isNotEmpty)
////                XCTAssertEqual(petsInfo.count, 1)
////
////                XCTAssertEqual(petsInfo[0].name, name)
////                XCTAssertEqual(petsInfo[0].age, age)
////                XCTAssertEqual(petsInfo[0].breed, breed)
////                XCTAssertEqual(petsInfo[0].lastVetVisit, date)
////                XCTAssertEqual(petsInfo[0].trackingChipId, trackingChipId)
////
////                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        petsProvider.errorPublisher
//            .sink { error in
//                guard let error = error else { return }
//                
//                XCTFail("Error: \(error.localizedDescription)")
//                sync.signal()
//            }
//            .store(in: &subscriptions)
//        
//        
//        Task {
//            await petsProvider.addPet(
//                petInfo: PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId),
//                onAddComplete: { self.addPet(
//                    petInfo: PetsModel(name: name2, age: age2, breed: breed2, lastVetVisit: date2, trackingChipId: trackingChipId2),
//                    toPetsProvider: petsProvider
//                )}
//            )
//        }
//        
//        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
//            XCTFail("Timed out")
//        }
//    }
//    
//    private func addPet(petInfo: PetsModel, toPetsProvider provider: PetsProviderProtocol) {
//        Task {
//            await provider.addPet(petInfo: petInfo, onAddComplete: { self.getPetsInfo(petsProvider: provider) })
//        }
//    }
}
