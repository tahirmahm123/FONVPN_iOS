//
//  Thread+Ext.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 28/09/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import Foundation
extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}
