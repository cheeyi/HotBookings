//
//  LocationManager.swift
//  HotBookings
//
//  Created by Barry Brown on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    // Singleton location manager
    static let sharedLocationManager = LocationManager()

    var locationManager: CLLocationManager
    var currentLocation: CLLocation?
    var currentCityName: String

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        currentCityName = ""

        super.init()

        locationManager.delegate = self
    }
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    func startUpdatingLocation() {
        debugPrint("Starting Location Updates")
        locationManager.startUpdatingLocation()
    }

    func startUpdatingLocation(completion:()->Void) {
        debugPrint("Starting Location Updates")
        locationManager.startUpdatingLocation()

        // Hacky: Wait 2 seconds before updating Departure Airport field
        let seconds = 2.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if (!self.currentCityName.isEmpty) {
                completion()
            }
        })

    }

    func stopUpdatingLocation() {
        debugPrint("Stop Location Updates")
        locationManager.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab last location
        let location: AnyObject? = (locations as NSArray).lastObject

        // Save location
        currentLocation = location as? CLLocation

        // Reverse geocode to get city, state and country strings
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.currentLocation!, completionHandler: { (placemarks, e) -> Void in
            if let _ = e {
                debugPrint("Error:  \(e!.localizedDescription)")
            }
            else {
                let placemark = placemarks!.last! as CLPlacemark

                self.currentCityName = placemark.locality!
                self.printLocation(self.currentLocation!)
                self.stopUpdatingLocation()
            }
        })
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        debugPrint("Update Location Error : \(error.description)")
    }

    func printLocation(currentLocation: CLLocation){
        debugPrint ("Current city: \(currentCityName)")
    }

    // MARK: - CLLocationManager Delegate

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}
