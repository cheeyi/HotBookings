//
//  RootViewModel.swift
//  HotBookings
//
//  Created by Chee Yi Ong on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import Foundation
import Alamofire


class RootViewModel {

    // MARK: - Map data
    private var request: Request?

    var regionDatas: [Region]?

    /// A location that represents the default center of the map
    static let mapCenter = CLLocationCoordinate2D(latitude: 44.9778, longitude: -93.2650) // Minneapolis

    /// Span of the map
    let span = MKCoordinateSpanMake(25.0, 40.0)

    /// An array of regions that will be drawn as pins on the map
    var locations = RootViewModel.mapAnnotationRegions()

    /// An array of hotel locations that are used as data source for the heat map
    // TODO: Hardcoded to map center for now. Look for hotel object
    // TODO: Use real hotel data from API
    var hotels = [Hotel(hotelID: "", lat: 44.9778, long: -93.2650, viewCount: 10, bookCount: 20, name: "Hotel Name")]
    var hotelLocations = [CLLocation(latitude: RootViewModel.mapCenter.latitude, longitude: RootViewModel.mapCenter.longitude)]
    var heatMapWeights = [CDouble(1)] // TODO: [CDouble]()

    /// Visible region of the map
    var region: MKCoordinateRegion {
        return MKCoordinateRegionMake(RootViewModel.mapCenter, span)
    }

    // MARK: - Business logic of VC

    func heatMapPointValues() -> [NSObject: AnyObject] {
        var pointValues = [NSValue: CDouble]()
        var currentIndex = 0
        let points = hotelLocations
            .map({MKMapPointForCoordinate($0.coordinate)})
            .map({NSValue(MKMapPoint: $0)})
        for point in points {
            pointValues[point] = heatMapWeights[currentIndex]
            currentIndex += 1
        }
        return pointValues
    }

    func parseHotelFromRegion() {
        guard let regionDatas = regionDatas else { return }
        hotels = regionDatas.reduce([Hotel]()) { return $0 + $1.hotels }
    }

    func updateHotelLocationsAndWeights() {
        parseHotelFromRegion()
        var newHotelLocations = [CLLocation]()
        var newHeatMapWeights = [CDouble]()
        hotels.forEach { (hotel) in
            if let latitude = hotel.lat, longitude = hotel.long, bookCount = hotel.bookCount {
                newHotelLocations.append(CLLocation(latitude: latitude, longitude: longitude))
                newHeatMapWeights.append(CDouble(bookCount))
            }
        }
        hotelLocations = newHotelLocations
        heatMapWeights = newHeatMapWeights
    }

    // MARK: - Private helpers

    /// Makes an array of CLLocations to be used as pins on the map view from an array of hardcoded regions
    private static func mapAnnotationRegions() -> [CLLocation] {
        var locationArray = [CLLocation]()
        let regions = [("-84.4152599684702", "33.7695976510102"), ("116.58803", "40.078777"), ("55.284832162674", "25.0290173679798"), ("-87.904787", "41.976928"), ("139.785104", "35.549477"), ("-0.449753", "51.470878"), ("-118.4032", "33.94415"), ("113.936462", "22.314508"), ("2.571006", "49.004061"), ("-96.9724988948161", "32.8849182143478"), ("29.0647877490895", "40.9700083253844"), ("7.77669681763539", "49.9852904576828"), ("121.799669", "31.151561"), ("4.82701834975881", "52.342304853281"), ("-73.782548", "40.644166"), ("103.897669410804", "1.3133489939857"), ("113.300114", "23.399299"), ("106.653457", "-6.122354"), ("-104.948295", "39.74483"), ("100.619788338049", "13.7733762708237"), ("-122.387996", "37.61594"), ("126.45092", "37.448424"), ("101.650619896921", "2.95971470973739"), ("-3.62707423715463", "40.4426815479153"), ("77.086145", "28.555741"), ("-115.010526159425", "35.94539741517"), ("-80.944074", "35.220985"), ("-80.27843", "25.79509"), ("-111.920205842314", "33.4829626369007"), ("-95.342119", "29.986609"), ("-122.30175", "47.44363"), ("103.955297", "30.5831"), ("-79.61142", "43.68146"), ("11.3812713547376", "48.2863202599745"), ("72.875404", "19.093916"), ("12.251165", "41.795617"), ("-0.16458", "51.156026"), ("151.154179061197", "-33.7765533456044"), ("113.816128", "22.645938"), ("2.13107432290943", "41.3436885508824"), ("-46.481788", "-23.425717"), ("121.455024199509", "31.1923805796266"), ("-81.307915", "28.431185"), ("121.396287978512", "25.0740929755467"), ("-99.08498", "19.434563"), ("102.926423", "25.098544"), ("-74.17747", "40.69085"), ("140.388451", "35.773258"), ("121.004298", "14.506506"), ("-93.2158489523997", "44.9672253165907")]
        for region in regions {
            guard let latitute = Double(region.1), longitude = Double(region.0) else { fatalError("Bad data") }
            locationArray.append(CLLocation(latitude: latitute, longitude: longitude))
        }
        return locationArray
    }

    // Get real data from server
    func requestData() {
        if request == nil {
            request = HotRequest.fetchData { (result) in
                switch result {
                case let Result.Failure(error):
                    print("Request failed: \(error)")
                case let Result.Success(regionsArray):
                    self.regionDatas = regionsArray
                    self.updateHotelLocationsAndWeights()
                }

                self.request = nil
            }
        }
    }
}
