//
//  LocationService.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import CoreLocation

final class LocationService: NSObject, LocationServiceProtocol {

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Never>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() async -> CLLocationCoordinate2D {
        manager.requestWhenInUseAuthorization()

        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let coordinate = locations.first?.coordinate
            ?? CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176) // Москва fallback
        continuation?.resume(returning: coordinate)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        continuation?.resume(returning: CLLocationCoordinate2D(
            latitude: 55.7558,
            longitude: 37.6176
        ))
    }
}
