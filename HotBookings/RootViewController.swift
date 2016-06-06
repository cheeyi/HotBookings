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
        textField.tintColor = UIColor.jetBlueColor()
        textField.textColor = UIColor.jetBlueColor()
        // Behavior and left margin
        textField.autocorrectionType = .No
        textField.clearButtonMode = .WhileEditing

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
        title = "Hot Bookings"
        view.addSubviews([searchForm])
    }

    private func setupConstraints() {
        let relationships = [
            "H:|-[searchForm]-|",
            "V:[topLayoutGuide]-[searchForm]"
        ]

        let views = [
            "searchForm": searchForm,
            "topLayoutGuide": topLayoutGuide
        ]

        let metrics = ["topMargin": CGFloat(8)]

        view.addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
    }
}
