//
//  ScrollViewBackgroundReader.swift
//  ScrollProxyV1
//
//  Created by Zoltan Lippai on 4/21/22.
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

/// A transparent view to introspect the `UIView` view tree and locate the `UIScrollView` of a
///  swiftUI `ScrollView`.
///
/// The background reader will pass the reference of this `UIScrollView` to its `Coordinator`, and
///  set its `Coordinator` as the `other` object of a `ScrollProxyProtocol` object through the
///  `setProxy(_:)` closure provided.
///
/// The `Coordinator` of this representable is the concrete object responsible to call the scrolling methods
/// on the underlying `UIScrollView`.
struct ScrollViewBackgroundReader: UIViewRepresentable {
    let setProxy: (ScrollProxyProtocol) -> ()
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        setProxy(coordinator)
        return coordinator
    }
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.backgroundReaderView = uiView
    }
}

// MARK: - Coordinator

extension ScrollViewBackgroundReader {
    /// The `Coordinator` of the background view.
    ///
    /// The `Coordinator` is responsible to locate the enclosing scrollview and to call the scrolling
    /// methods on the scrollview when the scroll proxy is delegating these calls.
    final class Coordinator: ScrollProxyProtocol {
        /// The background reader view - used as a starting point to locate the enclosing scroll view
        var backgroundReaderView: UIView!
        /// The enclosing scrollview - the first parent view of the `backgroundReaderView` which is
        /// of the type `UIScrollView`.
        var scrollView: UIScrollView?
                
        init() { }
        
        /// Returns the reference and content offset position of the view identified by the `identifier`.
        ///
        /// This method is used to locate the view, and convert the unit point anchor specified to a
        /// concrete scroll content offset position the scrollview should be positioned to.
        /// - Parameter identifier: The hashable identifier of the view the scrollview should
        /// position itself to.
        /// - Parameter anchor: The unit point anchor to specify which edge of the target view
        /// should be aligned with the edge of the container.
        private func locateTargetOffset(with identifier: AnyHashable, anchor: UnitPoint) -> (view: UIView, offset: CGPoint)? {
            guard let targetView = backgroundReaderView.window?.scrollAnchorView(with: identifier) else { return nil }
            guard let scrollView = targetView.enclosingScrollView else { return nil }
            self.scrollView = scrollView
            return (targetView, scrollView.convert(targetView.frame, from: targetView.superview).point(at: anchor, within: scrollView.bounds))
        }
        
        // MARK: UIScrollView scrolling
        
        func scroll(to identifier: AnyHashable, anchor: UnitPoint) {
            guard let target = locateTargetOffset(with: identifier, anchor: anchor) else { return }
            scrollView?.setContentOffset(target.offset, animated: true)
        }
        
        func scroll(to identifier: AnyHashable, anchor: UnitPoint, offset: CGPoint) {
            guard let target = locateTargetOffset(with: identifier, anchor: anchor) else { return }
            scrollView?.setContentOffset(target.offset + offset, animated: true)
        }
    }
}

extension CGRect {
    /// Returns a `CGPoint` coordinate the anchor point of the receiving rectangle within a container
    /// frame.
    ///
    /// This method is used to determine which position or edges of the frame of the target view and the
    /// scrollview should be aligned when an anchor position is specified.
    /// - Parameter anchor: The unit point anchor to determine which edges (or other, more fine
    /// grained position) should be aligned between the receiver and the container.
    /// - Parameter container: The bounds rectangle of the containing view, this is typically the
    /// bounds of the scrollview containing the target view.
    /// - Returns: The `CGPoint` coordinate of the content offset the scrollview should scroll to.
    func point(at anchor: UnitPoint, within container: CGRect) -> CGPoint {
        CGPoint(
            x: minX + anchor.x * (width - container.width),
            y: minY + anchor.y * (height - container.height)
        )
    }
}

extension CGPoint {
    /// Allows adding two CGPoints through the usual vector addition (i.e. memberwise addition).
    static func + (lhs: Self, rhs: Self) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
