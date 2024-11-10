//
//  Home.swift
//  SwiftUIScrollToHideHeaderView
//
//  Created by Hakob Ghlijyan on 10.11.2024.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    @State private var selection = 1
    
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
                NavigationStack {
                    GeometryReader {
                        let safeArea = $0.safeAreaInsets
                        let headerHeight = 60 + safeArea.top
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            HomeView()
                        }
                        .safeAreaInset(edge: .top, spacing: 0) {
                            HeaderView()
                                .padding(.bottom, 15)
                                .frame(height: headerHeight, alignment: .bottom)
                                .background(.bar)
                                .offset(y: -headerOffset)
                        }
                        .onScrollGeometryChange(for: CGFloat.self) { proxy in
                            let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                            return max(min(proxy.contentOffset.y + headerHeight, maxHeight) , 0)
                        } action: { oldValue, newValue in
                            let isScrollingUp = oldValue < newValue
                            headerOffset = min(max(newValue - lastNaturalOffset ,0), headerHeight)
                            self.isScrollingUp = isScrollingUp
                            naturalScrollOffset = newValue
                        }
                        .onScrollPhaseChange({ oldPhase, newPhase, context in
                            if !newPhase.isScrolling && (headerOffset != 0 || headerOffset != headerHeight) {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    if headerOffset > (headerHeight * 0.5) && naturalScrollOffset > headerHeight {
                                        headerOffset = headerHeight
                                    } else {
                                        headerOffset = 0
                                    }
                                    lastNaturalOffset = naturalScrollOffset - headerOffset
                                }
                                
                            }
                        })
                        .onChange(of: isScrollingUp, { oldValue, newValue in
                            lastNaturalOffset = naturalScrollOffset - headerOffset
                        })
                        .ignoresSafeArea(.container, edges: .top)
                    }
                }
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
        
        /*
         GeometryReader {
             let safeArea = $0.safeAreaInsets
             let headerHeight = 60 + safeArea.top
             
             ScrollView(.vertical, showsIndicators: false) {
 //                HomeView()
             }
             .safeAreaInset(edge: .top, spacing: 0) {
                 HeaderView()
                     .padding(.bottom, 15)
                     .frame(height: headerHeight, alignment: .bottom)
                     .background(.bar)
                     .offset(y: -headerOffset)
             }
             .onScrollGeometryChange(for: CGFloat.self) { proxy in
                 let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                 return max(min(proxy.contentOffset.y + headerHeight, maxHeight) , 0)
             } action: { oldValue, newValue in
                 let isScrollingUp = oldValue < newValue
                 headerOffset = min(max(newValue - lastNaturalOffset ,0), headerHeight)
                 self.isScrollingUp = isScrollingUp
                 naturalScrollOffset = newValue
             }
             .onScrollPhaseChange({ oldPhase, newPhase, context in
                 if !newPhase.isScrolling && (headerOffset != 0 || headerOffset != headerHeight) {
                     withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                         if headerOffset > (headerHeight * 0.5) && naturalScrollOffset > headerHeight {
                             headerOffset = headerHeight
                         } else {
                             headerOffset = 0
                         }
                         lastNaturalOffset = naturalScrollOffset - headerOffset
                     }
                     
                 }
             })
             .onChange(of: isScrollingUp, { oldValue, newValue in
                 lastNaturalOffset = naturalScrollOffset - headerOffset
             })
             .ignoresSafeArea(.container, edges: .top)
         }
         */
    }
    
    
//    Custom Tab Bar
    @ViewBuilder func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(tab.title == "" ? .largeTitle : .title2)
                        .symbolEffect(bouncesDown ? .bounce.down.byLayer : .bounce.up.byLayer, value: animatedTab.isAnimating)
                    
                    Text(tab.title)
                        .font(.subheadline)
                        .textScale(.secondary)
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

extension MainView {
    //HeaderView
    @ViewBuilder func HeaderView() -> some View {
        HStack(spacing: 20) {
            Image(colorScheme == .dark ? "YouTubeLogoWhite" : "YouTubeLogoBlack")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            
            Spacer(minLength: 0)
            
            Button("", systemImage: "airplayvideo") {
                
            }
            Button("", systemImage: "bell") {
                
            }
            Button("", systemImage: "magnifyingglass") {
                
            }
        }
        .font(.title3)
        .foregroundStyle(.primary)
        .padding(.horizontal, 15 )
    }
    
    //Icon Footer
    @ViewBuilder func icon(icon: String, title: String) -> some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            Text(title)
                .font(.caption)
        }
        .frame(width: 60, height: 40)
    }
}

struct HomeView: View {
    var body: some View {
        LazyVStack(spacing: 15) {
            ForEach(0 ..< 10) { _ in
                DummyCard()
            }
        }
        .padding(15)
    }
    
    //Dummy Card view
    @ViewBuilder func DummyCard() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 6).frame(height: 220)
            
            HStack(spacing: 10.0) {
                Circle().frame(width: 45, height: 45)
                
                VStack(alignment: .leading, spacing: 4) {
                    Rectangle().frame(height: 10)
                    
                    HStack(spacing: 10.0) {
                        Rectangle().frame(width: 100)
                        Rectangle().frame(width: 80)
                        Rectangle().frame(width: 60)
                    }
                    .frame(height: 10)
                }
            }
        }
        .foregroundStyle(.tertiary)
    }
}


// Tab's
enum Tab: String, CaseIterable {
    case home = "house"
    case chat = "bubble.left.and.text.bubble.right"
    case plus = "plus.circle.fill"
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
            "Subscibere"
        case .profile:
            "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
                .white
        case .chat:
                .blue
        case .plus:
                .brown
        case .notifications:
                .green
        case .profile:
                .yellow
        }
    }
}

// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

extension View {
    @ViewBuilder func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
