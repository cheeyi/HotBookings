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

    static let mapCenter = CLLocationCoordinate2D(latitude: 40.761267, longitude: -73.98565)
    let viewModel = RootViewModel(mapCenter: RootViewController.mapCenter, locations: [CLLocation(latitude: RootViewController.mapCenter.latitude, longitude: RootViewController.mapCenter.longitude)], span: MKCoordinateSpanMake(0.5, 0.5))

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

    let mapView = MKMapView().withAutoLayout()

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupMapView()
        setupConstraints()
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redEyeColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        title = "Hot Bookings"
        view.addSubviews([searchForm, mapView])
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.setRegion(viewModel.region, animated: true)
    }

    private func setupConstraints() {
        let relationships = [
            "H:|-[searchForm]-|",
            "H:|-[mapView]-|",
            "V:[topLayoutGuide]-[searchForm]-[mapView]-(verticalMargin)-|"
        ]

        let views = [
            "searchForm": searchForm,
            "mapView": mapView,
            "topLayoutGuide": topLayoutGuide
        ]

        let metrics = ["verticalMargin": CGFloat(8)]

        view.addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
    }
}

extension RootViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKPinAnnotationView

        if let pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("mapAnnotationPinIdentifier") as? MKPinAnnotationView {
            pinAnnotationView.annotation = annotation
            annotationView = pinAnnotationView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "mapAnnotationPinIdentifier")
            annotationView.pinTintColor = UIColor.firstClassBlueColor()
        }
        return annotationView
    }
}
