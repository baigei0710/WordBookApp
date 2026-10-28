//
//  WordBookEntry.swift
//  WordBookApp
//
//  Created by baigeii on 2026/9/24.
//
// 应用入口

import Foundation
import SwiftUI

@main
struct WordBookEntry: App {
    var body: some Scene {
        WindowGroup {
            MainUI()
                .frame(minWidth: 800, minHeight: 500)
                .preferredColorScheme(.light)
        }
        .defaultSize(width: 1440, height: 900)
        .windowResizability(.contentMinSize)
    }
}

