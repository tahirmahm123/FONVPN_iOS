//
//  AppConfiguration.swift
//  ICSMainFramework
//
//  Created by LEI on 5/14/15.
//  Copyright (c) 2015 TouchingApp. All rights reserved.
//

import Foundation

@objc public protocol AppLifeCycleProtocol: UIApplicationDelegate {}
private let sharedConfigInstance = AppConfig()
let appConfig = AppConfig.sharedConfig

public struct ConfigKey {
    public static let lifeCycle = "lifecycle"
    public static let custom = "custom"
}

public struct LifeCycleKey {
    public static let didFinishLaunchingWithOptions = "didFinishLaunchingWithOptions"
    public static let didEnterBackground = "didEnterBackground"
    public static let willEnterForeground = "willEnterForeground"
    public static let didBecomeActive = "didBecomeActive"
    public static let remoteNotification = "remoteNotification"
    public static let willTerminate = "willTerminate"
    public static let openURL = "openURL"
}

open class AppConfig {
    
    open var lifeCycleConfig = [String: [AppLifeCycleItem]]()
    open var customConfig = [String: AnyObject]()
    
    open class var sharedConfig: AppConfig {
        return sharedConfigInstance
    }
    
    open func loadConfig(_ fileName: String) {
        var components = fileName.components(separatedBy: ".")
        let type = components.popLast()
        let name = components.joined(separator: ".")
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            let configDict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
            loadConfig(configDict)
        }
    }
    
    open func loadConfig(_ dictionary: [String: AnyObject]) {
        if let lifeCycleDict = dictionary[ConfigKey.lifeCycle] as? [String: AnyObject] {
            loadLifeCycleConfig(lifeCycleDict)
        }
        if let lifeCycleDict = dictionary[ConfigKey.custom] as? [String: AnyObject] {
            loadCustomConfig(lifeCycleDict)
        }
    }
    
    func loadLifeCycleConfig(_ dictionary: [String: AnyObject]) {
        for (key, value) in dictionary {
            var items = [AppLifeCycleItem]()
            if let itemArray = value as? [AnyObject] {
                items = itemArray.map { AppLifeCycleItem(dictionary: $0 as! [String: AnyObject]) }.filter { $0 != nil }.map { $0! }
            }
            lifeCycleConfig[key] = items
        }
    }
    
    func loadCustomConfig(_ dictionary: [String: AnyObject]) {
        customConfig = dictionary
    }
    
}

public struct AppLifeCycleItem {
    public var object: AppLifeCycleProtocol?
    
    init?(dictionary: [String: AnyObject]) {
        if let objectString = dictionary["object"] as? String {
            if let classObject = NSClassFromString(objectString) as? NSObject.Type {
                object = classObject.init() as? AppLifeCycleProtocol
            }
        }
        
        if object == nil {
            return nil
        }
    }
}










