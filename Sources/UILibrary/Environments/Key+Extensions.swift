//
//  Key+Extensions.swift
//
//
//  Created by Cadis on 15/02/23.
//

import SwiftUI

private struct StateKey: EnvironmentKey {
    static let defaultValue = false
}

public extension EnvironmentValues {
    var isLoading: Bool {
        get { self[StateKey.self] }
        set { self[StateKey.self] = newValue }
    }
    
    @available(iOS 14.0, *)
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}
