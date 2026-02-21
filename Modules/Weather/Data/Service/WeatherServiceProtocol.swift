//
//  WeatherServiceProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import CoreLocation

protocol WeatherServiceProtocol {
    func fetchWeather(coordinate: CLLocationCoordinate2D) async throws -> ForecastResponseDTO
}
