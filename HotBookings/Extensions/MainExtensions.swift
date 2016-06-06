//
//  MainExtensions.swift
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import UIKit

extension UIView {

    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func addSubviews(views: [UIView]) {
        for subview in views {
            addSubview(subview)
        }
    }

    func addSubviews(views: UIView...) {
        return addSubviews(views)
    }

    func withAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UIStackView {

    convenience init(axis: UILayoutConstraintAxis, distribution: UIStackViewDistribution, alignment: UIStackViewAlignment, spacing: CGFloat? = nil) {
        self.init()
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        if let spacing = spacing {
            self.spacing = spacing
        }
    }

    /// Custom method that iterates through the arrangedSubviews array and adds them to the stack view
    func addArrangedSubviews(arrangedSubviews: [UIView]) -> Self {
        for view in arrangedSubviews {
            addArrangedSubview(view)
        }
        return self
    }
}
