//
//  PetsModel.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation

struct PetsModel: Codable, Identifiable {
    var id: UUID
    
    let name: String
    let age: Int
    let breed: String
    let lastVetVisit: Date?
    let trackingChipId: String?
    
    init(
        name: String,
        age: Int,
        breed: String,
        lastVetVisit: Date?,
        trackingChipId: String?
    ) {
        id = UUID()
        
        self.name = name
        self.age = age
        self.breed = breed
        self.lastVetVisit = lastVetVisit
        self.trackingChipId = trackingChipId
    }
    
    static func ==(lhs: PetsModel, rhs: PetsModel) -> Bool {
        lhs.name == rhs.name && lhs.breed == rhs.breed
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(breed)
    }
}

extension PetsModel: CustomStringConvertible {
    var description: String {
        String(data: (try? JSONEncoder().encode(self)) ?? Data(), encoding: .utf8) ?? ""
    }
}
