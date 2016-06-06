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
    let mapCenter: CLLocationCoordinate2D

    /// An array of locations that will be drawn as pins on the map
    let locations: [CLLocation]

    /// Span of the map
    let span: MKCoordinateSpan

    /// Visible region of the map
    var region: MKCoordinateRegion {
        return MKCoordinateRegionMake(mapCenter, span)
    }
}
