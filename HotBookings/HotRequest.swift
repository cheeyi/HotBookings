//
//  HotRequest.swift
//  HotBookings
//
//  Created by Bryan Rahn on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import Foundation
import Alamofire

typealias HotRequestClosure = (Result<[Region], NSError> -> Void)

struct HotRequest {
    static func fetchData(completion: HotRequestClosure) -> Request {
        return Alamofire.request(.GET, "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=6000409,6029225,6000216,6000461,6139112&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd")
            .responseJSON { (response) in
                if let error = response.result.error {
                    completion(Result.Failure(error))
                } else {
                    guard let results = response.result.value as? [String: AnyObject],
                        regions = results["regionTicker"] as? [[String: AnyObject]] else {
                        fatalError("Unable to parse regionTicker data")
                    }

                    // Region Result
                    var regionsResult = [Region]()

                    regions.forEach({ (regionDict) in
                        guard let regionID = regionDict["id"] as? Int,
                            regionName = regionDict["name"] as? String,
                            hotels = regionDict["hotelTicker"] as? [[String: AnyObject]] else {
                                fatalError("Unable to parse region data")
                        }

                        var hotelsResult = [Hotel]()
                        hotels.forEach({ (hotelDict) in
                            guard let hotelID = hotelDict["id"] as? Int,
                                viewCount = hotelDict["viewsCount"] as? String,
                                bookCount = hotelDict["bookingsCount"] as? String,
                                name = hotelDict["name"] as? String else {
                                    fatalError("Unable to parse hotelTicker data")
                            }

                            let hotel = Hotel(hotelID: String(hotelID), lat: nil, long: nil, viewCount: Int(viewCount), bookCount: Int(bookCount), name: name)
                            hotelsResult.append(hotel)
                        })

                        let regionResult = Region(regionID: String(regionID), name: regionName, hotels: hotelsResult)
                        regionsResult.append(regionResult)
                    })

                    completion(Result.Success(regionsResult))
                }
        }
    }
}
