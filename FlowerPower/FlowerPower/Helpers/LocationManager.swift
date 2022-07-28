//
//  LocationManager.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManager(manager: LocationManagerType, didUpdateLocations locations: [CLLocation])
}

protocol LocationManagerType {
    var location: CLLocation? { get }
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationDistance { get set }

    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    func isLocationServicesEnabled() -> Bool
}
extension CLLocationManager: LocationManagerType {
    var locationManagerDelegate: LocationManagerDelegate? {
        get {
            delegate as? LocationManagerDelegate? ?? nil
        }
        set {
            delegate = newValue as? CLLocationManagerDelegate? ?? nil
        }
    }
    func isLocationServicesEnabled() -> Bool {
        CLLocationManager.locationServicesEnabled()
    }
}
