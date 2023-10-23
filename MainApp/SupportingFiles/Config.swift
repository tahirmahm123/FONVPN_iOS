//
//  Config.swift
//  EvolveVPN
//
//  Created by Personal on 04/09/2022.
//


import Foundation
struct Config {
    static let serversListCacheFileName = "servers_cache1.json"
    static let openVPNLogFile = "OpenVPNLogs.txt"
    static let appGroup = "group.com.app.vpnlighting"
    static let openvpnTunnelTitle = "VPN Lightning OpenVPN"
    static let serviceStatusRefreshMaxIntervalSeconds: TimeInterval = 30
    static let stableVPNStatusInterval: TimeInterval = 0.5
}
