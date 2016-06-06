//
//  RootViewController.swift
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    // MARK: - Properties

    let viewModel = RootViewModel()

    // MARK: - Subviews

    let searchForm: UITextField = {
        let textField = UITextField().withAutoLayout()
        // Styling
        textField.backgroundColor = UIColor.jetBlueLightestGrayColor()
        textField.tintColor = UIColor.blackColor()
        textField.textColor = UIColor.jetBlueColor()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.clearColor().CGColor
        // Behavior and left margin
        textField.autocorrectionType = .No
        textField.clearButtonMode = .WhileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1)).withAutoLayout()
        textField.leftViewMode = .Always
        return textField
    }()

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupConstraints()
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redEyeColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        title = "HotBookings"
        view.addSubviews([searchForm])
    }

    private func setupConstraints() {
        let relationships = [
            "H:|-[searchForm]-|",
            "V:[topLayoutGuide]-[searchForm(==40)]"
        ]

        let views = [
            "searchForm": searchForm,
            "topLayoutGuide": topLayoutGuide
        ]

        let metrics = ["topMargin": CGFloat(8)]

        view.addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
    }
}
