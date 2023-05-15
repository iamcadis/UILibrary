//
//  File.swift
//
//
//  Created by Cadis on 17/02/23.
//

import Foundation

extension String: Identifiable {
    
    /// Use this modifier to conform String to Identifiable
    public var id: Int { hash }
    
    /// Use this modifier to check string is blank
    public var isBlank: Bool { trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty }
}

extension Optional where Wrapped == String {
    
    var _bound: String? {
        get { return self }
        set { self = newValue }
    }
    
    /// Use this modifier to make binding string optional
    public var wrapToRequired: String {
        get { return _bound ?? "" }
        set { _bound = newValue.isEmpty ? nil : newValue }
    }
    
    /// Use this modifier to check string is nil or blank
    public var isNilOrBlank: Bool {
        get { return (self ?? "").isBlank }
    }
    
    /// Use this modifier to check string is not blank
    public var isNotBlank: Bool {
        get { return (self ?? "").isBlank == false }
    }
    
}

