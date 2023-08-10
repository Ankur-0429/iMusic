//
//  ExpandedBottomSheet.swift
//  iMusic
//
//  Created by Ankur Ahir on 8/8/23.
//

import SwiftUI
import AVFAudio

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    var animation: Namespace.ID
    
    
    @State private var playerDuration: TimeInterval = 100
    private let maxDuration = TimeInterval(240)
    
    @StateObject private var volumeManager = VolumeManager()
    
    @State private var sliderValue: Double = 10
    private let maxSliderValue: Double = 100

    @State private var color: Color = .white

    private var normalFillColor: Color { color.opacity(0.5) }
    private var emptyColor: Color { color.opacity(0.3) }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(.ultraThickMaterial)
                            .opacity(animateContent ? 1:0)
                    })
                    .overlay(alignment: .top) {
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0:1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                
                VStack (spacing: 15) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1:0)
                        .offset(y: animateContent ? 0 : size.height)
                    
                    GeometryReader {
                        let size = $0.size
                        
                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        // Had to change to make it square image
                            .frame(width: size.width, height: size.width)
                            .clipShape(RoundedRectangle(cornerRadius: animateContent ? 15:5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                    .frame(width: size.width - 50)
//                    .padding(.vertical, size.height < 700 ? 5:30)
                    
                    PlayerView(size)
                        .offset(y: animateContent ? 0:size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10:0))
                .padding(.bottom, safeArea.bottom == 0 ? 10: safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    })
                    .onEnded({value in
                        withAnimation(.easeInOut(duration: 0.35)) {
                            if offsetY > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
                GeometryReader {
                    let size = $0.size
        
                    let spacing = size.height * 0.04
        
                    VStack(spacing: spacing) {
                        VStack(spacing: spacing) {
                            HStack(alignment: .center, spacing: 15) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Look What You Made Me do")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    Text("Taylor Swift")
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background {
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                                .environment(\.colorScheme, .light)
                                        }
                                }
                            }
                            
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .environment(\.colorScheme, .light)
                                .frame(height: 5)
                                .padding(.top, spacing)
                            
                            HStack {
                                Text("0.00")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer(minLength: 0)
                                
                                Text("3.33")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(height: size.height / 2.5, alignment: .top)
                        
                        HStack(spacing: size.width * 0.18) {
                            Button {
                                
                            } label: {
                                Image(systemName: "backward.fill")
                                    .font(size.height < 300 ? .title3 : .title)
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "pause.fill")
                                    .font(size.height < 300 ? .largeTitle : .system(size: 50))
                            }
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "forward.fill")
                                    .font(size.height < 300 ? .title3 : .title)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxHeight: .infinity)
                        
                        VStack(spacing: spacing) {
                            HStack(spacing: 15) {
                                VolumeSlider(value: $volumeManager.volume, inRange: 0...1, activeFillColor: color, fillColor: normalFillColor, emptyColor: emptyColor, height: 5) { started in

                                }
                                .frame(height: 30)
                            }
                            
                            HStack(alignment: .top, spacing: size.width * 0.18) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "quote.bubble")
                                        .font(.title2)
                                }
                                
                                VStack(spacing: 6) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "airpods.gen3")
                                            .font(.title2)
                                    }
                                    
                                    Text("Ankur's Airpods")
                                        .font(.caption)
                                }
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "list.bullet")
                                        .font(.title2)
                                }
                            }
                            .foregroundColor(.white)
                            .blendMode(.overlay)
                            .padding(.top, spacing)
                        }
                        .frame(height: size.height / 2.5, alignment: .bottom)
                }
            }
    }
}

struct ExpandedBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}

