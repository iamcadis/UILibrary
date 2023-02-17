//
//  File.swift
//  
//
//  Created by Cadis on 17/02/23.
//

import Foundation

extension Int: Identifiable {
    
    /// Use this modifier to conform Int to Identifiable
    ///
    public var id: Int { self }
}

extension String: Identifiable {
    
    /// Use this modifier to conform String to Identifiable
    ///
    public var id: Int { hash }
}
