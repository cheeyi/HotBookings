//
//  RootViewController.swift
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import UIKit
import CoreLocation
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

    let mapView = MKMapView().withAutoLayout()
    let heatMapImageView = UIImageView().withAutoLayout()

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupMapView()
        setupConstraints()
        determineCity()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupHeatMapImageView()
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redEyeColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        title = "Hot Bookings"
        view.addSubviews([searchForm, mapView, heatMapImageView])
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.setRegion(viewModel.region, animated: true)
        mapView.userInteractionEnabled = false // Because the heat map overlay is static
        addMapAnnotations(viewModel.locations)
    }

    private func setupHeatMapImageView() {
        let heatMap = LFHeatMap.heatMapForMapView(mapView, boost: viewModel.boost, locations: viewModel.locations, weights: viewModel.weight)
        heatMapImageView.contentMode = .Center
        heatMapImageView.image = heatMap
    }

    private func setupConstraints() {
        let relationships = [
            "H:|-[searchForm]-|",
            "H:|-[mapView]-|",
            "H:|-[heatMapImageView]-|",
            "V:[topLayoutGuide]-[searchForm]-[mapView]-(verticalMargin)-|"
        ]

        let views = [
            "searchForm": searchForm,
            "mapView": mapView,
            "heatMapImageView": heatMapImageView,
            "topLayoutGuide": topLayoutGuide
        ]

        let metrics = ["verticalMargin": CGFloat(8)]

        view.addCompactConstraints(relationships, metrics: metrics, views: views as [NSObject : AnyObject])
        heatMapImageView.topAnchor.constraintEqualToAnchor(mapView.topAnchor).active = true
        heatMapImageView.bottomAnchor.constraintEqualToAnchor(mapView.bottomAnchor).active = true
        heatMapImageView.heightAnchor.constraintEqualToAnchor(mapView.heightAnchor).active = true
        view.bringSubviewToFront(heatMapImageView)
    }

    private func determineCity() {
        // Request for location permission
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            LocationManager.sharedLocationManager.requestAuthorization()
            // TODO: LocationManager needs to fire notification or something to notify VC of city found in this case
        }
        else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            LocationManager.sharedLocationManager.startUpdatingLocation({
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.searchForm.text = LocationManager.sharedLocationManager.currentCityName
            })
        }
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
            annotationView.pinTintColor = UIColor.greenerPasturesColor()
        }
        return annotationView
    }

    /// Adds `MKPointAnnotations` for each `CLLocation` in the locations array
    private func addMapAnnotations(locations: [CLLocation]) {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
        }
    }
}
