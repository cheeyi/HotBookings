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

class InsetTextField : UITextField {
    var margin : CGFloat = 10.0

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, margin, margin);
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, margin, margin);
    }
}

class SearchFormView: UIView {
    var textField: InsetTextField = InsetTextField().withAutoLayout()

    override init (frame: CGRect) {
        super.init(frame : frame)

        setupViews()
    }

    convenience init () {
        self.init(frame:CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        // Blur Effect
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect).withAutoLayout()
        self.addSubview(blurEffectView)

        // Vibrancy Effect
        //let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        //let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect).withAutoLayout()

        textField.textColor = UIColor(white: 0.2, alpha: 0.7)
        textField.font = UIFont.boldSystemFontOfSize(18.0)

        // Add label to the vibrancy view
        //vibrancyEffectView.contentView.addSubview(textField)

        // Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(textField) //vibrancyEffectView)

        // Setup constraints
/*
        let r = [
            "H:|[vibrancyView]|",
            "V:|[vibrancyView]|",
            ]

        let v = [
            "vibrancyView": vibrancyEffectView,
            ]

        self.addCompactConstraints(r, metrics: nil, views: v as [NSObject : AnyObject])
*/
        let r1 = [
            "H:|[textField]|",
            "V:|[textField]|",
            ]

        let v1 = [
            "textField": textField,
            ]

        self.addCompactConstraints(r1, metrics: nil, views: v1 as [NSObject : AnyObject])

        // Constraints
        let r2 = [
            "H:|[blurView]|",
            "V:|[blurView]|",
            ]

        let v2 = [
            "blurView": blurEffectView,
            ]

        self.addCompactConstraints(r2, metrics: nil, views: v2 as [NSObject : AnyObject])
    }
}


class RootViewController: UIViewController {

    // MARK: - Properties

    let viewModel = RootViewModel()
    var selectedAnnotationView: MKAnnotationView?

    // MARK: - Subviews

    let searchFormView: SearchFormView = {
        let searchFormView = SearchFormView().withAutoLayout()
        return searchFormView
    }()

    let mapView = MKMapView().withAutoLayout()
    var heatmapOverlay = DTMHeatmap()

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupMapView()
        setupConstraints()
        determineCity()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.updateHeatMap), name: "updateHeatMap", object: nil)

        viewModel.requestData()
    }

    @objc private func updateHeatMap() {
        drawHeatMap()
    }

    func pushDetails(regionID: String) {
        guard let regions = viewModel.regionDatas else { return }
        regions.forEach { (region) in
            if region.regionID == regionID {
                let viewController = HotelListViewController(hotels: region.hotels, regionName: region.name)

                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                    target: self,
                    action: #selector(RootViewController.dismissDetailsVC))

                let nc = UINavigationController.init(rootViewController: viewController)
                nc.modalPresentationStyle = .OverCurrentContext
                self.presentViewController(nc, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Private Helpers

    func dismissDetailsVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupViewHierarchy() {
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = UIColor.redEyeColor()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        title = "Hot Bookings"
        view.addSubview(mapView)
        view.addSubview(searchFormView)
    }

    private func drawHeatMap() {
        if viewModel.hotelLocations.count > 0 {
            if self.mapView.overlays.count > 0 {
                self.mapView.removeOverlay(self.heatmapOverlay)
            }
            self.heatmapOverlay = DTMHeatmap()
            self.heatmapOverlay.setData(self.viewModel.heatMapPointValues(viewModel.hotelLocations))
            self.mapView.addOverlay(self.heatmapOverlay)

        } else {
            fatalError()
        }
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
            "H:|[searchFormView]|",
            "H:|[mapView]|",
            "V:[topLayoutGuide][searchFormView]",
            "V:[topLayoutGuide][mapView]|"
        ]

        let views = [
            "searchFormView": searchFormView,
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
                self.searchFormView.textField.text = LocationManager.sharedLocationManager.currentCityName
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
        var currentIndex = 0
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = RootViewModel.regionNames[currentIndex]
            mapView.addAnnotation(annotation)
            currentIndex += 1
        }
    }
}
