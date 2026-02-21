//
//  LocationService.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import CoreLocation

protocol LocationServiceProtocol: AnyObject {
    func requestLocation() async -> CLLocationCoordinate2D
}

final class LocationService: NSObject, LocationServiceProtocol {

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Never>?

    private let moscow = CLLocationCoordinate2D(
        latitude: 55.7558,
        longitude: 37.6176
    )

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() async -> CLLocationCoordinate2D {

        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            return moscow

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        @unknown default:
            return moscow
        }

        return await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        switch manager.authorizationStatus {

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            continuation?.resume(returning: moscow)
            continuation = nil

        default:
            break
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.first else {
            continuation?.resume(returning: moscow)
            continuation = nil
            return
        }

        continuation?.resume(returning: location.coordinate)
        continuation = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        continuation?.resume(returning: moscow)
        continuation = nil
    }
}
