//
//  HotelFetcher.swift
//  HotBookings
//
//  Created by Barry Brown on 6/7/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import Foundation

class HotelFetcher: NSObject {
    let apiKey = "7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd"
    let baseURL = "http://terminal2.expedia.com/x/mhotels/info?hotelId="
    let apiURL = "&apikey="
    let hotelID: String

    // ex: http://terminal2.expedia.com/x/mhotels/info?hotelId=582712&apikey=7Qfxob6PrJjAzZ51SgiM8R1ZOX1MHPEd
    init(hotelID: String) {
        self.hotelID = hotelID
    }

    private func makeRequestURL() -> NSURL {
        var requestURL = baseURL + hotelID + apiURL + apiKey
        requestURL = requestURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        return NSURL(string: requestURL)!
    }

    func fetchHotelLocation(completion:(CLLocationCoordinate2D?)->Void) {
        let requestURL = makeRequestURL()
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let downloadTask = session.dataTaskWithURL(requestURL, completionHandler: {(data, response, error) in
            guard let responseData = data else {
                debugPrint("ERROR \(error)")
            completion(nil)
            // Handle errors?
            return
        }
            let coordinate = self.handleData(responseData)
            completion(coordinate)
        })

        // Kick things off
        downloadTask.resume()
    }

    private func handleData(data: NSData) -> CLLocationCoordinate2D? {
        guard let jsonResponse = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) else {
            return nil
        }
        guard let lat = jsonResponse["latitude"] as? String,
            long = jsonResponse["longitude"] as? String else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
    }
}
