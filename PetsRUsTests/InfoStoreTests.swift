//
//  InfoStoreTests.swift
//  PetsRUsTests
//
//  Created by John Dumais on 10/7/23.
//

import XCTest
@testable import PetsRUs
import Combine

class InfoStoreTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        clearSubscriptions()
        clearInfoStore()
    }

    private func clearSubscriptions() {
        subscriptions.forEach { subscription in
            subscription.cancel()
        }
        
        subscriptions.removeAll()
    }
    
    private func clearInfoStore() {
        let sync = DispatchSemaphore(value: 0)
        
        Task {
            await InfoStore.shared.setPetsInfo(petsInfo: []) {
                sync.signal()
            }
        }
        
        sync.wait()
    }
        
    override func tearDownWithError() throws {
        clearSubscriptions()
        clearInfoStore()
    }

    func testGettingPetsFromEmptyStore() {
        let sync = DispatchSemaphore(value: 0)
                
        InfoStore.shared.errorPublisher
            .sink { error in
                guard let error = error else { return }
                
                XCTFail("Error: \(error.localizedDescription)")
                sync.signal()
            }
            .store(in: &subscriptions)
        
        InfoStore.shared.petsInfoPublisher
            .dropFirst()
            .sink { petsInfo in
                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
                
                XCTAssertTrue(petsInfo.isEmpty)
                sync.signal()
            }
            .store(in: &subscriptions)
        
        Task {
            await InfoStore.shared.getPetsInfo()
        }
        
        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
            XCTFail("Timed out")
        }
    }

    func testGetting1Pet() {
        let sync = DispatchSemaphore(value: 0)
        
        let name = "Gracie"
        let age = 14
        let breed = "Eskimo"
        let date = Date()
        let trackingChipId = "85"
        
        InfoStore.shared.errorPublisher
            .sink { error in
                guard let error = error else { return }
                
                XCTFail("Error: \(error.localizedDescription)")
                sync.signal()
            }
            .store(in: &subscriptions)
        
        InfoStore.shared.petsInfoPublisher
            .dropFirst()
            .sink { petsInfo in
                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
                
                XCTAssertTrue(petsInfo.isNotEmpty)
                XCTAssertTrue(petsInfo.count == 1)
                XCTAssertEqual(name, petsInfo[0].name)
                XCTAssertEqual(age, petsInfo[0].age)
                XCTAssertEqual(breed, petsInfo[0].breed)
                XCTAssertEqual(date, petsInfo[0].lastVetVisit)
                XCTAssertEqual(trackingChipId, petsInfo[0].trackingChipId)
                
                sync.signal()
            }
            .store(in: &subscriptions)
        
        Task {
            await InfoStore.shared.setPetsInfo(
                petsInfo: [PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId)],
                onSetComplete: { self.getPetsInfo() }
            )
        }
        
        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
            XCTFail("Timed out")
        }
    }
    
    private func getPetsInfo() {
        Task {
            await InfoStore.shared.getPetsInfo()
        }
    }
    
    func testGetting2Pets() {
        let sync = DispatchSemaphore(value: 0)
        
        let name = "Gracie"
        let age = 14
        let breed = "Eskimo"
        let date = Date()
        let trackingChipId = "85"
        
        let name2 = "Shasta"
        let age2 = 9
        let breed2 = "Eskimo"
        let date2 = Date()
        let trackingChipId2 = "86"
        
        InfoStore.shared.errorPublisher
            .sink { error in
                guard let error = error else { return }
                
                XCTFail("Error: \(error.localizedDescription)")
                sync.signal()
            }
            .store(in: &subscriptions)
        
        InfoStore.shared.petsInfoPublisher
            .dropFirst()
            .sink { petsInfo in
                guard let petsInfo = petsInfo else { XCTFail("Pets info is nil"); return}
                
                XCTAssertTrue(petsInfo.isNotEmpty)
                XCTAssertTrue(petsInfo.count == 2)
                
                XCTAssertEqual(name, petsInfo[0].name)
                XCTAssertEqual(age, petsInfo[0].age)
                XCTAssertEqual(breed, petsInfo[0].breed)
                XCTAssertEqual(date, petsInfo[0].lastVetVisit)
                XCTAssertEqual(trackingChipId, petsInfo[0].trackingChipId)
                
                XCTAssertEqual(name2, petsInfo[1].name)
                XCTAssertEqual(age2, petsInfo[1].age)
                XCTAssertEqual(breed2, petsInfo[1].breed)
                XCTAssertEqual(date2, petsInfo[1].lastVetVisit)
                XCTAssertEqual(trackingChipId2, petsInfo[1].trackingChipId)
                
                sync.signal()
            }
            .store(in: &subscriptions)
        
        Task {
            // Make sure our concrete instance can be substituted for its associated protocol
            let infoStore: InfoStoreProtocol = InfoStore.shared
            
            await infoStore.setPetsInfo(
                petsInfo: [
                    PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId),
                    PetsModel(name: name2, age: age2, breed: breed2, lastVetVisit: date2, trackingChipId: trackingChipId2)
                ],
                onSetComplete: { self.getPetsInfo() }
            )
        }
        
        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
            XCTFail("Timed out")
        }
    }
}
