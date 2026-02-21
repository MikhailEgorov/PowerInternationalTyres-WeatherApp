//
//  WeatherService.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

protocol WeatherServiceProtocol {
    func fetchWeather(lat: Double, lon: Double) async throws -> ForecastResponseDTO
}

protocol WeatherCacheProtocol {
    func save(_ weather: ForecastResponseDTO) throws
    func load() throws -> ForecastResponseDTO
}

final class WeatherService: WeatherServiceProtocol {

    private let client: NetworkClientProtocol
    private let apiKey = "YOUR_KEY"

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    func fetchWeather(lat: Double, lon: Double) async throws -> ForecastResponseDTO {

        guard let url = URL(string:
            "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=3"
        ) else {
            throw NetworkError.invalidURL
        }

        return try await client.request(url)
    }
}
