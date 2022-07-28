//
//  LocationManager.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {
    
    var didUpdateCurrentLocation: ((_ location: CLLocation) -> Void)?
    
    private var locationManager: LocationManagerType
    
    init(locationManager: LocationManagerType = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.locationManagerDelegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func startLocationTracking() {
        if locationManager.isLocationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: LocationManagerDelegate {
    func locationManager(manager: LocationManagerType, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = manager.location else { return }
        didUpdateCurrentLocation?(currentLocation)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager(manager: manager, didUpdateLocations: locations)
    }
}
