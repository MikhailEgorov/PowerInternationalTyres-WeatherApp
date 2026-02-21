//
//  WeatherInteractor.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

final class WeatherInteractor: WeatherInteractorProtocol {

    weak var output: WeatherInteractorOutput?

    private let service: WeatherServiceProtocol
    private let mapper: WeatherMapperProtocol
    private let cache: WeatherCacheProtocol

    init(
        service: WeatherServiceProtocol,
        mapper: WeatherMapperProtocol,
        cache: WeatherCacheProtocol
    ) {
        self.service = service
        self.mapper = mapper
        self.cache = cache
    }

    func fetchWeather(forceRefresh: Bool) async {

        do {

            // пока хардкод (позже заменим LocationService)
            let lat = 55.7558
            let lon = 37.6176

            let dto = try await service.fetchWeather(lat: lat, lon: lon)

            try cache.save(dto)

            var domain = try mapper.map(from: dto)

            domain = WeatherDomainModel(
                locationName: domain.locationName,
                current: domain.current,
                hourly: HourlyFilter.filter(
                    from: domain.hourly,
                    now: Date()
                ),
                forecast: domain.forecast
            )

            await MainActor.run {
                output?.didLoadWeather(domain)
            }

        } catch {

            if !forceRefresh,
               let cachedDTO = try? cache.load(),
               let cachedDomain = try? mapper.map(from: cachedDTO) {

                let filtered = HourlyFilter.filter(
                    from: cachedDomain.hourly,
                    now: Date()
                )

                let final = WeatherDomainModel(
                    locationName: cachedDomain.locationName,
                    current: cachedDomain.current,
                    hourly: filtered,
                    forecast: cachedDomain.forecast
                )

                await MainActor.run {
                    output?.didLoadWeather(final)
                }

            } else {

                await MainActor.run {
                    output?.didFail(with: error)
                }
            }
        }
    }
}
