//
//  Home.swift
//  SwiftUIScrollToHideHeaderView
//
//  Created by Hakob Ghlijyan on 10.11.2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader {
                let safeArea = $0.safeAreaInsets
                let headerHeight = 60 + safeArea.top
                
                ScrollView(.vertical, showsIndicators: false) {
                    HomeContentView()
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
    }
    
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
}

#Preview {
    HomeView()
}
