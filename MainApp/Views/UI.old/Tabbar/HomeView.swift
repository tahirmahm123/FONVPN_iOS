//
//  HomeView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 30/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import NetworkExtension

struct HomeView: View {
    @EnvironmentObject var appConstants: AppConstants
    @State private var notificationScreenShown = false
    @State private var vpnConfigurationScreenShown = false
    @State private var location: Location?
    @State private var connectVPNClicked = false
    var body: some View {
        ZStack(alignment: .bottom) {
                ScrollView([.vertical, .horizontal]) {
                    ZStack{
                        Image("World")
                            .frame(width: 5400, height: 3942)
                            .colorInvert()
                            .brightness(0.5)
                            .background(Color("MapBackgroundColor"))
                        Image(systemName: "location")
                            .background(Color.green)
                            .position(
                                x: CGFloat(location?.longitude ?? 0),
                                y: CGFloat(location?.latitude ?? 0)
                            )
                    }
                }.onAppear {
                    UIScrollView.appearance().bounces = false
                    UIScrollView.appearance().showsVerticalScrollIndicator = false
                    UIScrollView.appearance().showsHorizontalScrollIndicator = false
                }
            VStack{
                VStack {
                    if appConstants.daysLeft <= 3 {
                        Warning(message: appConstants.daysLeft >= 0 ? "You have \(appConstants.daysLeft) days before renewal" : "Your Account has been expired.")
                    }
                }
                .padding()
                VStack{
                    RoundedRectangle(cornerRadius: 16.0)
                        .fill(Color.gray)
                        .frame(
                            width: 60.0,
                            height: 6.0
                        )
                        .padding(.top,7)
                    ConnectionView(connectVPN: $connectVPNClicked, allowConfigurationToggle: $vpnConfigurationScreenShown)
                        .padding(20)
                        //                    .background(Color("BackgroundColor"))
                }
                .background(Color("ConnectionPopOverBG"))
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]) )
            }
            
        }
        .onAppear(perform: {
            Task {
//                await vpn.prepare()
            }
            location = getCoordinatesBy(latitude: 51.509865, longitude: -0.118092)
            appConstants.validateNotificationPermission(action: {
                notificationScreenShown.toggle()
            }, onSuccess: {
                appConstants.validateVPNConfiguration(action: {
                    vpnConfigurationScreenShown.toggle()
                })
            })
        })
        .compatibleFullScreen(isPresented: $notificationScreenShown) {
            NotificationPermission(onDismiss: {
                notificationScreenShown.toggle()
                vpnConfigurationScreenShown.toggle()
            })
        }
        .compatibleFullScreen(isPresented: $vpnConfigurationScreenShown) {
            ProfileConfigurationPermission(onDismiss: {
                vpnConfigurationScreenShown.toggle()
            }, onSuccess: {
                vpnConfigurationScreenShown.toggle()
                if connectVPNClicked {
                    NotificationCenter.default.post(name: Notification.Name.ServerSelected, object: nil)
                }
            })
        }
    }
    
    func getCoordinatesBy(latitude: Double, longitude: Double) -> Location {
        
        let bitmapWidth: Double = 5400
        let bitmapHeight: Double = 3942
        
        var x: Double = longitude.toRadian() - 0.18
        var y: Double = latitude.toRadian()
        
        let yStrech = 0.542
        let yOffset = 0.053
        
        y = yStrech * log(tan(0.25 * Double.pi + 0.4 * y)) + yOffset
        
        x = ((bitmapWidth) / 2) + (bitmapWidth / (2 * Double.pi)) * x
        y = (bitmapHeight / 2) - (bitmapHeight / 2) * y
        let location = Location(longitude: Float(x), latitude: Float(y))
        return location
    }
    
    
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppConstants())
    }
}
