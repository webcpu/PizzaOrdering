//
//  LocationService.swift
//  PizzaOrdering
//
//  Created by liang on 2022-01-06.
//

import Foundation
import CoreLocation
import SwiftLocation
import Alamofire
import Combine
import CocoaLumberjackSwift

class LocationService {
    static let `default` = LocationService()
    
    var options: GPSLocationOptions {
        let options = GPSLocationOptions()
        options.subscription = .continous // continous updated until you stop it
        options.accuracy = .house //.root
        options.minDistance = 10 // updated every 10 meters or more
        options.minTimeInterval = 30 // updated each 30 seconds or more
        options.activityType = .automotiveNavigation// .other
        options.timeout = .delayed(5) // 5 seconds of timeout after auth granted
        return options
    }
    
    var publisher: PassthroughSubject<CLLocation, Never>
    
    init() {
        self.publisher = PassthroughSubject<CLLocation, Never>()
        if let location = SwiftLocation.lastKnownGPSLocation {
            self.publisher.send(location)
        }
    }
    
    func getCurrentLocation() { //-> Result<CLLocation, LocationError>{
        SwiftLocation.gpsLocationWith(options)
            .then(didUpdate)
    }
    
    func didUpdate(_ result: Result<CLLocation, LocationError>) {
        switch result {
        case .success(let newData):
            DDLogInfo("New location: \(newData)")
            self.publisher.send(newData)
        case .failure(let error):
            DDLogInfo("An error has occurred: \(error.localizedDescription)")
        }
    }
}
