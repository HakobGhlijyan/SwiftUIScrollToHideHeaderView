//
//  Tab.swift
//  SwiftUIScrollToHideHeaderView
//
//  Created by Hakob Ghlijyan on 10.11.2024.
//

import SwiftUI

// Tab's
enum Tab: String, CaseIterable {
    case home = "house"
    case chat = "bubble.left.and.text.bubble.right"
    case plus = "plus.circle"
    case notifications = "bell.and.waves.left.and.right"
    case profile = "person.circle.fill"

    var title: String {
        switch self {
        case .home:
            "Home"
        case .chat:
            "Shorts"
        case .plus:
            ""
        case .notifications:
            "Subsciberes"
        case .profile:
            "Profile"
        }
    }
}

// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
