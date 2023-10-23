//
//  FastestServersView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

//import SwiftUI
//
//struct FastestServersView: View {
//    var body: some View {
//        AnimationView(name: "Loader",animationSpeed: 1,contentMode: .scaleAspectFill, play: .constant(true))
//        .frame(width: 250, height: 50)
//
//    }
//}
//
//struct FastestServersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FastestServersView()
//    }
//}
import SwiftUI

struct FastestView: View {
    @State private var isViewVisible = true
    @GestureState private var dragState = DragState.inactive
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
                case .inactive, .dragging(translation: .zero):
                    return .zero
                case .dragging(let translation):
                    return translation
            }
        }
        
        var isDraggingUp: Bool {
            if case .dragging(let translation) = self {
                return translation.height < 0
            }
            return false
        }
        
        var heightOffset: CGFloat {
            let minHeight: CGFloat = 100
            let maxHeight: CGFloat = 300
            let gestureHeight = translation.height
            let height = minHeight - gestureHeight
            
            if height > maxHeight {
                return maxHeight
            } else if height < minHeight {
                return minHeight
            }
            
            return height
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .foregroundColor(.red)
                .frame(width: .infinity, height: 100)
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .updating($dragState) { drag, state, _ in
                            state = .dragging(translation: drag.translation)
                        }
                        .onEnded { drag in
                            if drag.translation.height < 0 {
                                self.isViewVisible = true
                            } else {
                                self.isViewVisible = false
                            }
                        }
                )
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 100, height: isViewVisible ? dragState.heightOffset : 0)
                .opacity(isViewVisible ? 1 : 0)
                .offset(y: isViewVisible ? 0 : 100)
                .animation(.easeInOut)
            
        }
        
    }
    
}

struct FastestView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
