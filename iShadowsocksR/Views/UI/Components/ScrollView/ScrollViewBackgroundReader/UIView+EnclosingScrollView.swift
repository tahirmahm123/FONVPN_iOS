//
//  UIView+ContainerScrollView.swift
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

import UIKit

extension UIView {
    /// Returns the first (closest) `UIScrollView` parent of the receiver.
    ///
    /// This property returns `nil` if no scrollview is found.
    var enclosingScrollView: UIScrollView? {
        sequence(first: self, next: { $0.superview })
            .first(where: { $0 is UIScrollView }) as? UIScrollView
    }
}
