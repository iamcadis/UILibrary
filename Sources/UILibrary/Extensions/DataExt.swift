//
//  File.swift
//
//
//  Created by Cadis on 17/02/23.
//

import SwiftUI

extension String: Identifiable {
    
    /// Use this modifier to conform String to Identifiable
    public var id: Int { hash }
    
    /// Use this modifier to check string is blank
    public var isBlank: Bool { trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty }
}

extension Optional where Wrapped == String {
    
    /// Use this modifier to check string is nil or blank
    public var isNilOrBlank: Bool {
        get { return (self ?? "").isBlank }
    }
    
    /// Use this modifier to check string is not blank
    public var isNotBlank: Bool {
        get { return (self ?? "").isBlank == false }
    }
    
}

extension Optional {
    public func ifNil(replaceWith defaultValue: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return try defaultValue()
        }
    }
}

public extension Binding {
    func ifNil<T>(replaceWith defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
