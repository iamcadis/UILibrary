//
//  File.swift
//  
//
//  Created by Cadis on 16/02/23.
//

import SwiftUI

extension View {
    
    @ViewBuilder func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}


