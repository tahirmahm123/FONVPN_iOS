//
//  ScrollProxyProtocol.swift
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

import Foundation
import SwiftUI

/// The proxy protocol declares the programmatic scrolling methods we can use on the scrollview.
protocol ScrollProxyProtocol {
    /// Scrolls to a child view with the specified identifier.
    ///
    /// - Parameter identifier: The unique scroll identifier of the child view.
    /// - Parameter anchor: The unit point anchor to describe which edge of the child view
    /// should be snap to.
    func scroll(to identifier: AnyHashable, anchor: UnitPoint)
    /// Scrolls to a child view with the specified identifier and adjusted by the offset position.
    ///
    /// - Parameter identifier: The unique scroll identifier of the child view.
    /// - Parameter anchor: The unit point anchor to describe which edge of the child view
    /// should be snap to.
    /// - Parameter offset: Extra offset on top of the identified view's position.
    func scroll(to identifier: AnyHashable, anchor: UnitPoint, offset: CGPoint)
}
