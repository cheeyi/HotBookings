//
//  RootViewModel.swift
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import Foundation

struct RootViewModel {

    // MARK: - Map data

    /// A location that represents the center of the map
    static let mapCenter = CLLocationCoordinate2D(latitude: 44.9778, longitude: -93.2650) // Minneapolis

    /// Span of the map
    let span = MKCoordinateSpanMake(25.0, 40.0)

    /// An array of locations that will be drawn as pins on the map
    // TODO: Hardcoded to map center for now
    var locations = [CLLocation(latitude: RootViewModel.mapCenter.latitude, longitude: RootViewModel.mapCenter.longitude)]

    /// Property defining the 'heat' of a location on the heat map
    var weights = [NSNumber(int: 25)]

    /// Boost property as required by LFHeatMap
    var boost = Float(0.5)

    /// Visible region of the map
    var region: MKCoordinateRegion {
        return MKCoordinateRegionMake(RootViewModel.mapCenter, span)
    }

    // MARK: - Business logic of VC

    func heatMapPointValues() -> [NSObject: AnyObject] {
        var pointValues = [NSValue: CDouble]()
        let points = locations
            .map({MKMapPointForCoordinate($0.coordinate)})
            .map({NSValue(MKMapPoint: $0)})
        for point in points {
            pointValues[point] = CDouble(1)
        }
        return pointValues
    }
}
