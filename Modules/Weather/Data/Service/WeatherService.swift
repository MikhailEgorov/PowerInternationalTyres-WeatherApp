//
//  WeatherService.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import CoreLocation

final class WeatherService: WeatherServiceProtocol {

    private let network: NetworkClientProtocol
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"

    init(network: NetworkClientProtocol) {
        self.network = network
    }

    func fetchWeather(coordinate: CLLocationCoordinate2D) async throws -> ForecastResponseDTO {

        let urlString =
        "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(coordinate.latitude),\(coordinate.longitude)&days=3"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        return try await network.request(url: url)
    }
}
