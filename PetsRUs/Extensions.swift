//
//  Extensions.swift
//  PetsRUs
//
//  Created by John Dumais on 10/7/23.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { self }
}

extension Collection {
    var isNotEmpty: Bool {
        !isEmpty
    }
}
