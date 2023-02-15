//
//  RefreshableScrollViewTests.swift
//
//
//  Created by Cadis on 15/02/23.
//

import UILibrary
import SwiftUI
import XCTest

final class UILibraryTests: XCTestCase {
    
    func testRefreshableScrollView() {
        let view = RefreshableScrollView(action: { }, content: { Text("Hello, world!") })
        XCTAssertNotNil(view)
    }
    
    #if os(iOS)
    func testUrlImageView() {
        let view = UrlImageView(url: "https://www.logodesign.net/images/home-page-logo-03.png")
        XCTAssertNotNil(view)
    }
    #endif
}
