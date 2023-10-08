//
//  InfoStoreProtocol.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation

protocol InfoStoreProtocol {
    func getPetsInfo() async -> Result<[PetsModel], Error>
    func setPetsInfo(petsInfo: [PetsModel]) async -> Result<Bool, Error>
}
