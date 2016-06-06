//
//  MultilineNavigationBarTitleView.swift
//  Packages
//
//  Created by Barry Brown on 1/15/16.
//  Copyright © 2016 Mobiata. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class MultilineNavigationBarTitleView: UIView {

    private let titleLabel: UILabel = {
        var label = UILabel().withAutoLayout()
        label.font = UIFont.systemFontOfSize(15.0)
        label.textAlignment = .Center
        return label
    }()

    private let subtitleLabel: UILabel = {
        var label = UILabel().withAutoLayout()
        label.font = UIFont.systemFontOfSize(11.0)
        label.textAlignment = .Center
        return label
    }()

    // MARK: Initializers

    init(title: String, subtitle: String?, textColor: UIColor) {
        super.init(frame: CGRect.zero)
        setupViews()
        enlargeTitleFontForSingleLine(subtitle == nil)
        titleLabel.text = title
        titleLabel.textColor = textColor
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = textColor

        let size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        frame = CGRect(origin: CGPoint.zero, size: size)
    }

    func setTitleAccessibilityLabel(titleAccessibilityLabel: String) {
        titleLabel.accessibilityLabel = titleAccessibilityLabel
    }

    func setSubtitleAccessibilityLabel(subtitleAccessibilityLabel: String) {
        subtitleLabel.accessibilityLabel = subtitleAccessibilityLabel
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding is not supported")
    }

    // MARK: Private

    private func setupViews() {
        backgroundColor = UIColor.clearColor()
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[title][subtitle]|", options: [], metrics: nil, views: ["title" : titleLabel, "subtitle" : subtitleLabel])
        constraints += titleLabel.constraintsToFillSuperviewHorizontally()
        constraints += subtitleLabel.constraintsToFillSuperviewHorizontally()
        NSLayoutConstraint.activateConstraints(constraints)
    }

    private func enlargeTitleFontForSingleLine(isSingleLine: Bool) {
        if isSingleLine {
            titleLabel.font = UIFont.systemFontOfSize(18.0)
        }
    }
}

extension UIView {
    func constraintsToFillSuperviewHorizontally() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("This view does not have a superview: \(self)")
        }
        return [leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor, constant: 0),
         trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor, constant: 0)]
    }
}
