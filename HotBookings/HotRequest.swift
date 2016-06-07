//
//  HotRequest.swift
//  HotBookings
//
//  Created by Bryan Rahn on 6/6/16.
//  Copyright © 2016 Expedia Inc. All rights reserved.
//

import Foundation
import Alamofire

typealias HotRequestClosure = (Result<[Hotel], NSError> -> Void)

struct HotRequest {
    static func fetchHeatMapData(completion: HotRequestClosure) {

    }
}
