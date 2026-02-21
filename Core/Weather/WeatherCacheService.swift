//
//  WeatherCacheService.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

final class WeatherCacheService: WeatherCacheProtocol {

    private let fileName = "weather_cache.json"

    private var fileURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    func save(_ weather: ForecastResponseDTO) throws {
        let data = try JSONEncoder().encode(weather)
        try data.write(to: fileURL, options: .atomic)
    }

    func load() throws -> ForecastResponseDTO {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(ForecastResponseDTO.self, from: data)
    }
}
