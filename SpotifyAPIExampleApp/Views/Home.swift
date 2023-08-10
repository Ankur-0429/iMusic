//
//  Home.swift
//  SpotifyAPIExampleApp
//
//  Created by Ankur Ahir on 8/9/23.
//

//
//  Home.swift
//  iMusic
//
//  Created by Ankur Ahir on 8/8/23.
//

import SwiftUI

struct Home: View {
    
    @State private var expandSheet: Bool = false
    @State private var animateContent: Bool = false
    @Namespace private var animation
    @ObservedObject var keyboardObserver = KeyboardObserver()
    
    var body: some View {
        TabView {
            SampleTab("Listen Now", "play.circle.fill") {
                SavedAlbumsGridView()
            }
            
            SampleTab("Browse", "square.grid.2x2.fill") {
                Text("Browse")
            }
            SampleTab("Radio", "dot.radiowaves.left.and.right") {
                Text("Radio")
            }
            SampleTab("Music", "play.square.stack") {
                Text("Music")
            }
            SampleTab("Search", "magnifyingglass") {
                SearchForTracksView()
            }
        }
        .tint(.red)
        .safeAreaInset(edge: .bottom) {
            if !keyboardObserver.isVisible {
                CustomBottomSheet()
            }
        }
        .overlay {
            if expandSheet {
                ExpandedBottomSheet(expandSheet: $expandSheet, animation: animation)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
        
    }
    
    @ViewBuilder
    func CustomBottomSheet() -> some View {
        MusicInfo(expandSheet: $expandSheet, animation: animation)
            .background(.thinMaterial)
            .matchedGeometryEffect(id: "BGVIEW", in: animation)
            .frame(height: 70)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
            }
            .offset(y: -49)
    }
    
    @ViewBuilder
    func SampleTab<Content: View>(_ title: String, _ icon: String, @ViewBuilder content: () -> Content) -> some View {
        NavigationView {
            content()
        }
        .tabItem {
            Image(systemName: icon)
            Text(title)
        }
        .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct MusicInfo: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            
            ZStack {
                if !expandSheet {
                    GeometryReader {
                        let size = $0.size

                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: expandSheet ? 15:5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)

                }
            }
            .frame(width: 45, height: 45)
            
            
            Text("Look What You Made Me do")
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.horizontal, 15)
            
            Spacer(minLength: 0)
            
            Button(action: {}) {
                Image(systemName: "pause.fill")
                    .font(.title2)
            }
            
            Button(action: {}) {
                Image(systemName: "forward.fill")
                    .font(.title2)
            }
            .padding(.leading, 25)
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .frame(height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet = true
            }
        }
    }
}
