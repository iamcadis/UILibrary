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
}

@available(iOS 14.0, *)
public extension EnvironmentValues {
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}

#if os(iOS)
public extension UIApplication {
    
    var currentWindows: [UIWindow]? {
        let windowScenes = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene })
        let windows =  windowScenes.compactMap({ $0 }).first?.windows.filter({ $0.isKeyWindow })
        return windows
    }
    
    var controller: UIViewController? {
        return UIApplication.shared.currentWindows?.first?.rootViewController
    }
    
}
#endif
