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

    /// An array of locations that will be drawn as pins on the map
    let locations = [CLLocation(latitude: RootViewModel.mapCenter.latitude, longitude: RootViewModel.mapCenter.longitude)]

    /// Span of the map
    let span = MKCoordinateSpanMake(0.5, 0.5)

    /// Visible region of the map
    var region: MKCoordinateRegion {
        return MKCoordinateRegionMake(RootViewModel.mapCenter, span)
    }
}
