//
//  Extensions.swift
//  SwiftUIScrollToHideHeaderView
//
//  Created by Hakob Ghlijyan on 10.11.2024.
//

import SwiftUI

extension View {
    @ViewBuilder func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
