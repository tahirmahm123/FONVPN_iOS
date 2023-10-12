//
//  ConnectedServerView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import NetworkExtension

struct ConnectedServerView: View {
    @EnvironmentObject var app: AppConstants
    @State var connectionState: NEVPNStatus
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    let vpnStatusChangeNotification = NotificationCenter.default
        .publisher(for: Notification.Name.VPNTimer)
//    @AppStorage("savedTime") var savedTime: TimeInterval = 0
    
    var body: some View {
        VStack {
            Image(app.selectedServer!.country_code.lowercased())
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text("\(String(describing: app.selectedServer!.country)) - \(String(describing: app.selectedServer!.name))")
                .font(.system(size: 16, weight: .bold))
            Text(timeString(elapsedTime))
                .font(.system(size: 16, weight: .semibold))
        }
//        .onReceive(vpnStatusChangeNotification) { (notification: Notification) in
//            print("Timer Changed Notification")
//            
//            print("VPNStatusDidChange: \(notification.vpnStatus)")
//            switch notification.vpnStatus {
//                case .connected:
//                    startTimer()
//                case .connecting, .disconnecting, .disconnected:
//                    stopTimer()
//            }
//        }
        .onAppear(perform: {
//            elapsedTime = savedTime
            if connectionState == .connected {
                startTimer()
            }
        })
        .onDisappear(perform: {
//            savedTime = elapsedTime
        })
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                elapsedTime += 1
                if elapsedTime.truncatingRemainder(dividingBy: 10)  == 0 {
//                    savedTime = elapsedTime
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
//        savedTime = 0
    }
    
    func timeString(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ConnectedServerView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedServerView(connectionState: .connected)
            .environmentObject(AppConstants.shared)
    }
}
