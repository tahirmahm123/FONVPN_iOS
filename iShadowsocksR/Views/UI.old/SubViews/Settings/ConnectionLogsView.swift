//
//  ConnectionLogsView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct ConnectionLogsView: View {
    @State var logs: [String] = []
    @State private var showToast = false
    @Binding var visible: Bool
    var body: some View {
        NavigationView {
            VStack {
                if logs.count > 0 {
                    List(logs, id: \.self) { log in
                        Text(log)
                            .multilineTextAlignment(.leading)
                    }
                    .listStyle(.plain)
                } else {
                    GeometryReader { geometry in
                        VStack{
                            Image("ConnectionLogBackground")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.6)
                                .opacity(0.5)
                                .padding(.bottom)

                            Text("No Connection Logs")
                                .fontWeight(.semibold)
                            Text("Connection Logs will be displayed here")
                                .fontWeight(.regular)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)                    }
                    
                    
                }
            }
            .navigationBarTitle("Connection Logs", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                if logs.count > 0 {
                    UIPasteboard.general.string = logs.joined(separator: "\n")
                    showToast.toggle()
                }
            }) {
                if logs.count > 0 {
                    Image("CopyLogs")
                }
            })
            .navigationBarItems(leading: Button(action: {
                visible.toggle()
            }) {
                Image(systemName: "xmark")
            })
            
        }
        .onAppear(perform:  {
            guard let cfg = cfg else {
                return
            }
            logs = cfg.debugLog?.components(separatedBy: "\n")  ?? []
        })
        .toast(isPresenting: $showToast, duration: 1, tapToDismiss: true, alert: {
            AlertToast(displayMode: .banner(.pop), type: .regular, title: "Logs Copied to Clipboard")
        })
        .accentColor(Color("ThemeColor"))
    }
}

struct ConnectionLogsView_Previews: PreviewProvider {
    static var previews: some View {
        @State var showToast = false
        ConnectionLogsView(logs: [], visible: $showToast)
    }
}
