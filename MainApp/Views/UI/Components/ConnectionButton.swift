//
//  PaymentCell.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 13/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
// import PotatsoLibrary

struct ConnectionButton: View {
    @Binding var vpnStatus: VPNStatus
    @Binding var loading: Bool
    let radius: CGFloat = 95
    var gradientColors: [Color] {
        if loading {
            return [Color("ProcessingColor1"), Color("ProcessingColor2")]
        }else{
            switch vpnStatus {
                case .off:
                    return [Color("DisconnectedColor1"), Color("DisconnectedColor2")]
                case .connecting, .disconnecting:
                    return [Color("ProcessingColor1"), Color("ProcessingColor2")]
                case .on:
                    return [Color("ConnectedColor1"), Color("ConnectedColor2")]
            }
        }
    }
    let shadowRadius: CGFloat = 2
    let shadowOffset: CGSize = CGSize(width: 10, height: 10)
    var shadowColor: Color {
        return gradientColors.first!.opacity(0.5)
    }
    
    var body: some View {
//        VStack {
            ZStack {
                Circle()
                    .fill(RadialGradient(
                        gradient: Gradient(colors: [.clear,shadowColor]),
                        center: .center, startRadius: 100, endRadius: 50
                    ))
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ))
                    .padding(10)
                VStack{
                    if loading {
                        ActivityIndicator{ view in
                            view.color = .white
                        }
                        .frame(width: 35, height: 35)
                        
                        Text("Processing...")
                            .foregroundColor(.white)
                            .font(.system(size: 20).weight(.bold))
                    } else {
                        switch vpnStatus {
                            case .off:
                                Image(systemName: "lock.slash")
                                    .renderingMode(.template)
                                    .resizable().scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.white)
                                Text("Tap to")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20).weight(.bold))
                                Text("Connect")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20).weight(.bold))
                            case .connecting, .disconnecting:
                                ActivityIndicator{ view in
                                    view.color = .white
                                }
                                .frame(width: 35, height: 35)
                                
                                Text(vpnStatus == .connecting ? "Connecting..." : "Disconnecting...")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20).weight(.bold))
                            case .on:
                                Image(systemName: "lock")
                                    .renderingMode(.template)
                                    .resizable().scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.white)
                                Text("Tap to")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20).weight(.bold))
                                Text("Disconnect")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20).weight(.bold))
                        }
                    }
                }
            }
            .frame(width: radius * 2, height: radius * 2)
//        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
//        .background(Color.black)
    }
        
}

struct ConnectionButton_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionButton(vpnStatus: .constant(.off), loading: .constant(true))
    }
}

