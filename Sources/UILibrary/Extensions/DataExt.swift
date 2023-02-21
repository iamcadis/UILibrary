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
