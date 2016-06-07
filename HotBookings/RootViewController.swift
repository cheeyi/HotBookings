//
//  RootViewController.swift
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import UIKit
import DTMHeatmap
import CoreLocation


class RootViewController: UIViewController {

    // MARK: - Properties

    let viewModel = RootViewModel()
    var selectedAnnotationView: MKAnnotationView?

    // MARK: - Subviews

    let searchForm: UITextField = {
        let textField = UITextField().withAutoLayout()
        textField.backgroundColor = UIColor.jetBlueLightestGrayColor()
        textField.tintColor = UIColor.jetBlueColor()
        textField.textColor = UIColor.jetBlueColor()
        textField.autocorrectionType = .No
        textField.clearButtonMode = .WhileEditing
        return textField
    }()

    let mapView = MKMapView().withAutoLayout()
    let heatmapOverlay = DTMHeatmap()

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupMapView()
        setupConstraints()
        determineCity()

        viewModel.requestData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        drawHeatMap()
    }

    func pushDetails(regionID: String) {
        guard let regions = viewModel.regionDatas else { return }
        regions.forEach { (region) in
            if region.regionID == regionID {
                let viewController = HotelListViewController(hotels: region.hotels, regionName: region.name)
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    // MARK: - Private Helpers

    private func setupViewHierarchy() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redEyeColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        title = "Hot Bookings"
        view.addSubviews([searchForm, mapView])
    }

    private func drawHeatMap() {
        viewModel.updateHotelLocationsAndWeights()
        heatmapOverlay.setData(viewModel.heatMapPointValues())
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.rotateEnabled = false
        mapView.addOverlay(heatmapOverlay)
        mapView.setRegion(viewModel.region, animated: true)
        addMapAnnotations(viewModel.locations)
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

    private func determineCity() {
        // Request for location permission
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            LocationManager.sharedLocationManager.requestAuthorization()
            // TODO: LocationManager needs to fire notification or something to notify VC of city found in this case
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            LocationManager.sharedLocationManager.startUpdatingLocation({
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.searchForm.text = LocationManager.sharedLocationManager.currentCityName
            })
        }
    }
}

extension RootViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        selectedAnnotationView = view
    }

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        selectedAnnotationView = nil
    }

    func showRegionDetails() {
        guard let coordinates = selectedAnnotationView?.annotation?.coordinate else { return }
        let coordinateTuple = (coordinates.longitude, coordinates.latitude) // Because RootViewModel.regions is (long,lat) format
        var currentIndex = 0
        var regionID = ""
        for region in RootViewModel.regions {
            if Double(region.0) == coordinateTuple.0 && Double(region.1) == coordinateTuple.1 {
                regionID = String(RootViewModel.regionIDs[currentIndex])
            }
            currentIndex += 1
        }
        pushDetails(regionID)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView: MKPinAnnotationView

        if let pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("mapAnnotationPinIdentifier") as? MKPinAnnotationView {
            pinAnnotationView.annotation = annotation
            annotationView = pinAnnotationView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "mapAnnotationPinIdentifier")
            annotationView.pinTintColor = UIColor.greenerPasturesColor()
        }
        let detailsButton = UIButton(type: .DetailDisclosure)
        detailsButton.tintColor = UIColor.firstClassBlueColor()
        detailsButton.addTarget(self, action: #selector(self.showRegionDetails), forControlEvents: .TouchUpInside)
        annotationView.rightCalloutAccessoryView = detailsButton
        annotationView.canShowCallout = true
        return annotationView
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        return DTMHeatmapRenderer(overlay: overlay)
    }

    /// Adds `MKPointAnnotations` for each `CLLocation` in the locations array
    private func addMapAnnotations(locations: [CLLocation]) {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Region Title"
            mapView.addAnnotation(annotation)
        }
    }
}
