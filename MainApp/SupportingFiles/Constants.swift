//
//  Constants.swift
//  EvolveVPN
//
//  Created by Personal on 04/09/2022.
//


import Foundation
import UIKit
import NetworkExtension

let appName = "FON VPN"
let appName1 = "FON"
let appName2 = "VPN"
let supportEmail = "support@fonvpn.com"
let AcceptTermsURL = "https://www.fonvpn.com/tos.php?mobileview=true"
let PrivacyPolicyURL = "https://www.fonvpn.com/privacy-policy.php?mobileview=true"
let configurationKeyRevnueCat = ""

let urlAuthToken = "urlAuthToken"
let isLogedIn = "isLogin"
let isPaidUser = "isPaidUser"
let isFromUserName = "isFromUserName"
let isTermsAndConditionAccepted = "isTermsAndConditionAccepted"
let UserName = "userName"
let userUUID = "userUUID"
let isProUser = "isProUser"
let Password = "password"
let ApiKey = "apiKey"
let CERT = "cert"
let ActiveDevice = "activeDevices"
let TimeStamp = "timeStamp"
let ExpiryDate = "expiryDate"
let SubscriptionPlan = "subscriptionPlan"
let SelectedProtocol = "selectedProtocol"
let SelectedPortAndProtocol = "selectedPortAndProtocol"
let PrivateKey = "privateKey"
let PublicKey = "publicKey"
let LocalIp = "localIp"
let RotationDays = "rotationDays"
let KeyGeneratedDate = "keyGeneratedDate"
let NotAskToReconnect = "notAskToReconnect"
let userDefaults = UserDefaults.standard
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let deviceId = UIDevice.current.identifierForVendor?.uuidString
let deviceName = UIDevice.modelName
let minPingCheckInterval: TimeInterval = 10
let KillSwitch = "killSwitch"
let AntiTracker = "AntiTracker"
let AutoSelectFastServer = "autoSelectFastServer"
let SelectRandomServer = "selectRandomServer"
let DiagnosticLogs = "diagnosticLogs"
let DnsEnabled = "dnsEnabled"
let DnsOverHT = "dnsOverHT"
let SelectedProtocolSegment = "SelectedProtocolSegment"
let SecureDNSKey = "secureDNSkey"
let ResolvedDNSOutsideVPN = "resolvedDNSOutsideVPN"
let ResolvedDNSInsideVPN = "ResolvedDNSInsideVPN"
let CustomDNSProtocol = "customDNSProtocol"
let CustomDNS = "customDNS"
let connectionStatus = "connectionStatus"
let LastSelectedServer = "lastSelectedServer"
let RecentSelectedServer = "recentSelectedServer"
let QuickSettingsServer = "quickSettingsServer"
let SelectedApperance = "selectedAppearance"
let PreviousPort = "previousPort"
let appGroup = "group.com.app.vpnlighting"
//API Manager
//let apiBaseDomain = "856f-182-176-167-41.ngrok-free.app"
let apiBaseDomain = "api.fonvpn.com"
let apiBaseURL = "https://"+apiBaseDomain

var vpnStatus: VPNStatus = .off
let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
let RecommendedIndex = "recommendedIndex"
let TimeInterval = "timeInterval"
let LastTimeSaved = "LastTimeSave"
let DefaultDns1 = "defaultdns1"
let DefaultDns2 = "defaultdns2"


let ServerFilePath = "ServersFilePath"
let ServerFileName = "servers.json"
extension Notification.Name {
    public static let ShouestLoader = Notification.Name("shouestLoader")
    public static let ShouestError = Notification.Name("shouestError")
    public static let PingDidComplete = Notification.Name("pingDidComplete")
    public static let ActiveDevicesUpdated = Notification.Name("activeDevicesUpdated")
    public static let ExpiredStatusRefreshed = Notification.Name("expiredStatusRefreshed")
    public static let FavouritesStatusChanged = Notification.Name("favouritesStatusChanged")
    public static let UpdateResolvedDNS = Notification.Name("UpdateResolvedDNS")
    public static let UpdateResolvedDNSInsideVPN = Notification.Name("UpdateResolvedDNSInsideVPN")
    public static let ResolvedDNSError = Notification.Name("ResolvedDNSError")
    public static let ReconnectWithNewSettings = Notification.Name("ReconnectWithNewSettings")
    public static let VPNProtocolChanged = Notification.Name("VPNProtocolChanged")
    public static let PurchaseStatusRefreshed = Notification.Name("purchaseStatusRefreshed")
    public static let LoggedOutUser = Notification.Name("loggedOutUser")
    public static let VPNTimer = Notification.Name("vpnTimer")
    public static let APIProgress = Notification.Name("apiProgress")
    public static let ServerSelected = Notification.Name("serverSelected")
    public static let ShowLoginOrHome = Notification.Name("showLoginOrHome")
    public static let PopToLaunch = Notification.Name("launchScreenNavigation")
    public static let FocusOnMap = Notification.Name("FocusOnMap")
    public static let ShowGuestError = Notification.Name("showGuestError")
    public static let StartSearching = Notification.Name("StartSearching")
    public static let LoginActionWithUrl = Notification.Name("LoginActionWithUrl")
    public static let RedirectToRoot = Notification.Name("RedirectToRoot")
}

