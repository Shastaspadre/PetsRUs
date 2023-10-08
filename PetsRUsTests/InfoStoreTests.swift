//
//  InfoStoreTests.swift
//  PetsRUsTests
//
//  Created by John Dumais on 10/7/23.
//

import XCTest
@testable import PetsRUs

class InfoStoreTests: XCTestCase {
    override func setUpWithError() throws {
        clearInfoStore()
    }
    
    private func clearInfoStore() {
        let sync = DispatchSemaphore(value: 0)

        Task {
            _ = await InfoStore.shared.setPetsInfo(petsInfo: [])
            sync.signal()
        }

        sync.wait()
    }
        
    override func tearDownWithError() throws {
        clearInfoStore()
    }

    func testGettingPetsFromEmptyStore() {
        let sync = DispatchSemaphore(value: 0)
                
        Task {
            do {
                let petsInfo = try await InfoStore.shared.getPetsInfo().get()
                XCTAssertTrue(petsInfo.isEmpty)
                sync.signal()
            } catch {
                XCTFail("getPetsInfo failed with error: \(error.localizedDescription)")
                sync.signal()
            }
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
        
        Task {
            do {
                let setResult = try await InfoStore.shared.setPetsInfo(
                    petsInfo: [PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId)]
                )
                .get()
                
                XCTAssertTrue(setResult)
                
                let petsInfo = try await InfoStore.shared.getPetsInfo().get()
                
                XCTAssertTrue(petsInfo.isNotEmpty)
                XCTAssertEqual(petsInfo.count, 1)
                
                XCTAssertEqual(name, petsInfo[0].name)
                XCTAssertEqual(age, petsInfo[0].age)
                XCTAssertEqual(breed, petsInfo[0].breed)
                XCTAssertEqual(date, petsInfo[0].lastVetVisit)
                XCTAssertEqual(trackingChipId, petsInfo[0].trackingChipId)

                sync.signal()
            } catch {
                XCTFail("Got an error: \(error.localizedDescription)")
                sync.signal()
            }
        }

        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
            XCTFail("Timed out")
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
        
        Task {
            do {
                let setResult = try await InfoStore.shared.setPetsInfo(
                    petsInfo: [
                        PetsModel(name: name, age: age, breed: breed, lastVetVisit: date, trackingChipId: trackingChipId),
                        PetsModel(name: name2, age: age2, breed: breed2, lastVetVisit: date2, trackingChipId: trackingChipId2)
                    ]
                    
                )
                .get()
                
                XCTAssertTrue(setResult)
                
                let petsInfo = try await InfoStore.shared.getPetsInfo().get()
                
                XCTAssertTrue(petsInfo.isNotEmpty)
                XCTAssertEqual(petsInfo.count, 2)
                
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
            } catch {
                XCTFail("Got an error: \(error.localizedDescription)")
                sync.signal()
            }
        }

        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
            XCTFail("Timed out")
        }
    }
    
    func testEmptyInsertReportsNothingAdded() {
        let sync = DispatchSemaphore(value: 0)
                
        Task {
            do {
                let added = try await InfoStore.shared.setPetsInfo(petsInfo: []).get()
                XCTAssertFalse(added)
                sync.signal()
            } catch {
                XCTFail("getPetsInfo failed with error: \(error.localizedDescription)")
                sync.signal()
            }
        }
        
        if sync.wait(timeout: .now() + DispatchTimeInterval.seconds(1)) == .timedOut {
            XCTFail("Timed out")
        }
    }
}
