//
//  MockLocationManager.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation
import CoreLocation
@testable import FlowerPower

final class MockLocationManager: LocationManagerType {
    var enableLocation = true
    var isUpdatingLocation = false
    
    var location: CLLocation? = CLLocation(latitude: 46.749400, longitude: 23.600759)
    var locationManagerDelegate: LocationManagerDelegate?
    var desiredAccuracy: CLLocationDistance = 10
    
    func requestWhenInUseAuthorization() {}
    
    func startUpdatingLocation() {
        isUpdatingLocation = true
        if let location = location {
            locationManagerDelegate?.locationManager(manager: self, didUpdateLocations: [location])
        }
    }
    
    func stopUpdatingLocation() {
        isUpdatingLocation = false
    }
    
    func isLocationServicesEnabled() -> Bool { enableLocation }
}
