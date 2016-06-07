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
    static func fetchData(completion: HotRequestClosure) -> [Request] {
        var requests = [Request]()
        for requestString in HotRequest.requestStringsForAllRegions() {
            requests.append(Alamofire.request(.GET, requestString)
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
                })
        }
        return requests
    }

    static func requestStringsForAllRegions() -> [String] {
        return [
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[0]),\(RootViewModel.regionIDs[1]),\(RootViewModel.regionIDs[2]),\(RootViewModel.regionIDs[3]),\(RootViewModel.regionIDs[4])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[5]),\(RootViewModel.regionIDs[6]),\(RootViewModel.regionIDs[7]),\(RootViewModel.regionIDs[8]),\(RootViewModel.regionIDs[9])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[10]),\(RootViewModel.regionIDs[11]),\(RootViewModel.regionIDs[12]),\(RootViewModel.regionIDs[13]),\(RootViewModel.regionIDs[14])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[15]),\(RootViewModel.regionIDs[16]),\(RootViewModel.regionIDs[17]),\(RootViewModel.regionIDs[18]),\(RootViewModel.regionIDs[19])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[20]),\(RootViewModel.regionIDs[21]),\(RootViewModel.regionIDs[22]),\(RootViewModel.regionIDs[23]),\(RootViewModel.regionIDs[24])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[25]),\(RootViewModel.regionIDs[26]),\(RootViewModel.regionIDs[27]),\(RootViewModel.regionIDs[28]),\(RootViewModel.regionIDs[29])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[30]),\(RootViewModel.regionIDs[31]),\(RootViewModel.regionIDs[32]),\(RootViewModel.regionIDs[33]),\(RootViewModel.regionIDs[34])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[35]),\(RootViewModel.regionIDs[36]),\(RootViewModel.regionIDs[37]),\(RootViewModel.regionIDs[38]),\(RootViewModel.regionIDs[39])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[40]),\(RootViewModel.regionIDs[41]),\(RootViewModel.regionIDs[42]),\(RootViewModel.regionIDs[43]),\(RootViewModel.regionIDs[44])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd",
            "http://terminal2.expedia.com/x/trends/regions/ticker?viewDuration=30m&bookingDuration=48h&regionIds=\(RootViewModel.regionIDs[45]),\(RootViewModel.regionIDs[46]),\(RootViewModel.regionIDs[47]),\(RootViewModel.regionIDs[48]),\(RootViewModel.regionIDs[49])&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd"
        ]
    }
}
