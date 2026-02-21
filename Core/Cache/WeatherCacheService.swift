//
//  WeatherCacheService.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

final class WeatherCacheService: WeatherCacheProtocol {

    private var cached: WeatherDomainModel?

    func save(_ model: WeatherDomainModel) {
        cached = model
    }

    func load() -> WeatherDomainModel? {
        cached
    }
}
