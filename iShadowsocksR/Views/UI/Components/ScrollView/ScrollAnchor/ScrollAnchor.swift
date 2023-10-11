//
//  ScrollAnchor.swift
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

/// The scroll anchor view is used to mark pieces of scrollview content as possible scroll-to targets.
///
/// We are using a representable implementation to add a custom UIKit UIView to the swiftUI view
/// hierarchy, and use this view for two goals:
/// - Hold onto a unique identifier which is used in the scrolling methods for programmatic scrolling
/// - locate the view in the view tree and obtain their frame/origin for the UIScrollView APIs to scroll the
/// content.
struct ScrollAnchorView: UIViewRepresentable {
    /// Any arbitrary identifier.
    ///
    /// This is used later to specify which child view we want to scroll to. The identifier is shared with
    /// the `ScrollAnchorBackgroundView`.
    let id: AnyHashable
    
    func makeUIView(context: Context) -> ScrollAnchorBackgroundView {
        let view = ScrollAnchorBackgroundView()
        view.id = id
        return view
    }
    
    func updateUIView(_ uiView: ScrollAnchorBackgroundView, context: Context) { }
    
    final class ScrollAnchorBackgroundView: UIView {
        /// Any arbitrary identifier.
        ///
        /// This is used later to specify which child view we want to scroll to.
        var id: AnyHashable!
    }
}

extension View {
    /// Marks the given view as a potential scroll-to target for programmatic scrolling.
    ///
    /// - Parameter id: An arbitrary unique identifier. Use this id in the scrollview reader's proxy
    /// methods to scroll to this view.
    func scrollAnchor(_ id: AnyHashable) -> some View {
        background(ScrollAnchorView(id: id))
    }
}

extension UIView {
    /// Returns the receiver  if the receiver was of
    /// `ScrollAnchorView.ScrollAnchorBackgroundView` type, and the `id` of the view
    ///  matched the `identifier` argument of this method.
    func asAnchor(with identifier: AnyHashable) -> UIView? {
        guard let anchor = self as? ScrollAnchorView.ScrollAnchorBackgroundView,
                anchor.id == identifier else {
            return nil
        }
        return anchor
    }
    
    /// Walks through the subview tree to find the first child view of type
    /// `ScrollAnchorView.ScrollAnchorBackgroundView` that matched the specified `id`.
    /// - Parameter id: The scroll id of the receiver we are looking for.
    /// - Returns: The first child view in the subview tree that matched the given identifier and has the
    /// `ScrollAnchorView.ScrollAnchorBackgroundView` type. This method returns `nil`,
    /// if no such child view was found.
    ///
    /// This method will walk through the subview tree recursively until the specified view is found.
    func scrollAnchorView(with id: AnyHashable) -> UIView? {
        for subview in subviews {
            if let anchor = subview.asAnchor(with: id) ?? subview.scrollAnchorView(with: id) {
                return anchor
            }
        }
        return nil
    }
}
