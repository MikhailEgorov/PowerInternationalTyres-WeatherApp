//
//  LocationServiceProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import CoreLocation

protocol LocationServiceProtocol {
    func requestLocation() async -> CLLocationCoordinate2D
}
