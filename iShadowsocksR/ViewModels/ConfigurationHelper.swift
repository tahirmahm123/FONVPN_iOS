//
//  ConfigurationHelper.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 10/08/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import Foundation
import PotatsoModel
import PotatsoLibrary
import RealmSwift

class ConfigurationHelper {
    static let shared = ConfigurationHelper()
    
    func buildProxyConfiguration(host: String, port: Int, authScheme: String, password: String) -> ConfigurationGroup {
        
        let proxyNode = ProxyNode()
        proxyNode.type = .Shadowsocks
        proxyNode.name = appName
        proxyNode.host = host
        proxyNode.port = port
        proxyNode.authscheme = authScheme
        proxyNode.user = nil
        proxyNode.password = password
        proxyNode.ota = false
        proxyNode.ssrProtocol = nil
        proxyNode.ssrProtocolParam = nil
        proxyNode.ssrObfs = nil
        proxyNode.ssrObfsParam = nil
        
        proxyNode.ssrotEnable = false
        proxyNode.ssrotDomain = ""
        proxyNode.ssrotPath = ""
        return CurrentGroupManager.shared.changeProxyNode(proxy: proxyNode)
        
//        return config
    }
    
}

class CurrentGroupManager {
    
    static let shared = CurrentGroupManager()
    
    fileprivate init() {
        _groupUUID = Manager.sharedManager.defaultConfigGroup.uuid
    }
    
    var onChange: ((ConfigurationGroup?) -> Void)?
    
    fileprivate var _groupUUID: String {
        didSet(o) {
            self.onChange?(group)
        }
    }
    
    lazy var group: ConfigurationGroup = {
        if let group = DBUtils.get(self._groupUUID, type: ConfigurationGroup.self, filter: "deleted = false") {
            return group
        } else {
            let defaultGroup = Manager.sharedManager.defaultConfigGroup
            setConfigGroupId(defaultGroup.uuid)
            return defaultGroup
        }
    }()
    
    func setConfigGroupId(_ id: String) {
        if let _ = DBUtils.get(id, type: ConfigurationGroup.self, filter: "deleted = false") {
            self._groupUUID = id
        } else {
            self._groupUUID = Manager.sharedManager.defaultConfigGroup.uuid
        }
    }
    
    
    public func changeProxyNode(proxy: ProxyNode) -> ConfigurationGroup {
        do {
            try DBUtils.hardDeleteAll(type: ProxyNode.self)
            try DBUtils.add(proxy)
            try ConfigurationGroup.changeProxyNode(forGroupId: self._groupUUID, nodeId: proxy.uuid)
//            self.group.proxyNodes.removeAll()
//            self.group.proxyNodes.append(proxy)
        }catch {
           print("Error changinig proxy")
        }
        
//        if let proxyNode = DBUtils.get(proxy.uuid, type: ProxyNode.self){
//            group.proxyNodes.append(proxy)
//        }
        return self.group
    }
}
