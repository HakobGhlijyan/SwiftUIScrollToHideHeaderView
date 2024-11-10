//
//  HomeView.swift
//  SwiftUIScrollToHideHeaderView
//
//  Created by Hakob Ghlijyan on 10.11.2024.
//

import SwiftUI

struct HomeContentView: View {
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

#Preview {
    ScrollView(.vertical, showsIndicators: false) {
        HomeContentView()
    }
}
