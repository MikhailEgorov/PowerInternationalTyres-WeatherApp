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

    private func resolve(with coordinate: CLLocationCoordinate2D) {
        guard let continuation = continuation else { return }
        self.continuation = nil
        manager.stopUpdatingLocation()
        continuation.resume(returning: coordinate)
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        let coordinate = locations.first?.coordinate
            ?? CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)

        resolve(with: coordinate)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {

        let fallback = CLLocationCoordinate2D(
            latitude: 55.7558,
            longitude: 37.6176
        )

        resolve(with: fallback)
    }
}
