//
//  Home.swift
//  SwiftUIScrollToHideHeaderView
//
//  Created by Hakob Ghlijyan on 10.11.2024.
//

import SwiftUI

struct MainView: View {
    // View Properties
    @State private var activeTab: Tab = .home
    // All Tab's
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    // Bounce Property
    @State private var bouncesDown: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                //Tab View
                //1
                HomeView()
                    .setUpTab(.home)
                
                //2
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.chat.title)
                }
                .setUpTab(.chat)
                
                //3
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.plus.title)
                }
                .setUpTab(.plus)
                
                //4
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.notifications.title)
                }
                .setUpTab(.notifications)
                
                //5
                NavigationStack {
                    VStack {
                        
                    }
                    .navigationTitle(Tab.profile.title)
                }
                .setUpTab(.profile)
            }
            
            CustomTabBar()
        }
    }
    
    //Custom Tab Bar
    @ViewBuilder func CustomTabBar() -> some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(tab.title == "" ? .largeTitle : .title2)
                        .symbolEffect(bouncesDown ? .bounce.down.byLayer : .bounce.up.byLayer, value: animatedTab.isAnimating)
                    
                    if !tab.title.isEmpty {
                        Text(tab.title)
                            .font(.subheadline)
                            .textScale(.secondary)
                    }
                   
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(activeTab == tab ? Color.primary : Color.gray.opacity(0.7))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        activeTab = tab
                        animatedTab.isAnimating = true
                    } completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            animatedTab.isAnimating = nil
                        }
                    }
                }
            }
        }
        .background(.bar)
    }
    
}

#Preview {
    MainView()
}
