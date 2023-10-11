//
//  ScrollReader.swift
//  ScrollProxyV1
//
//  Created by Zoltan Lippai on 4/22/22.
//  Copyright © 2022 DoorDash. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import SwiftUI

/// The scroll reader object - a custom replacement for Apple's ScrollViewReader.
///
/// The reader exposes a `proxy` argument to its content. Through this proxy object the content can
/// communicate with the scroll view and programmatically modify its content offset.
struct ScrollReader<ScrollViewContent: View>: View {
    /// The view content of the scrollview.
    let content: (ScrollProxyProtocol) -> ScrollViewContent
    /// The private proxy object vended to the content of the reader.
    private let proxy = __ScrollProxy()
    
    /// Designated initializer to construct a scroll reader view.
    ///
    /// - Parameter content: The view content of the reader.
    /// - Parameter proxy: The proxy object reference the content can use for programmatic
    /// scrolling.
    init(@ViewBuilder content: @escaping (_ proxy: ScrollProxyProtocol) -> ScrollViewContent) {
        self.content = content
    }
    
    var body: some View {
        content(proxy)
            .background(
                ScrollViewBackgroundReader(
                    setProxy: {
                        proxy.other = $0
                    }
                )
            )
    }
    
    /// A concrete implementation of the scroll proxy protocol.
    ///
    /// The proxy object will delegate the scroll method calls to the `other` object, which is set
    /// to be the `Coordinator` of the scrollview background reader later on.
    final fileprivate class __ScrollProxy: ScrollProxyProtocol {
        /// An other object conforming to the scroll proxy protocol, this object is expected to
        /// communicate with the scrollview directly to move its content offset.
        ///
        /// In this example project, this reference is the `Coordinator` of the scrollview background
        /// reader.
        fileprivate var other: ScrollProxyProtocol?
        
        init() { }
        
        func scroll(to identifier: AnyHashable, anchor: UnitPoint) {
            other?.scroll(to: identifier, anchor: anchor)
        }
        
        func scroll(to identifier: AnyHashable, anchor: UnitPoint, offset: CGPoint) {
            other?.scroll(to: identifier, anchor: anchor, offset: offset)
        }
    }
}
