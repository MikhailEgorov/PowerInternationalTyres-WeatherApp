//
//  WeatherInteractor.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//
import CoreLocation

final class WeatherInteractor: WeatherInteractorProtocol {

    weak var output: WeatherInteractorOutput?

    private let service: WeatherServiceProtocol
    private let mapper: WeatherMapperProtocol
    private let locationService: LocationServiceProtocol
    private let cache: WeatherCacheProtocol

    init(service: WeatherServiceProtocol,
         mapper: WeatherMapperProtocol,
         locationService: LocationServiceProtocol,
         cache: WeatherCacheProtocol) {
        self.service = service
        self.mapper = mapper
        self.locationService = locationService
        self.cache = cache
    }

    func loadWeather() {
        Task { await fetch() }
    }

    func refresh() {
        Task { await fetch() }
    }

    func fetchWeatherForTests() async {
        await fetch()
    }

    @MainActor
    private func fetch() async {
        do {
            let coordinate = await locationService.requestLocation()
            let dto = try await service.fetchWeather(coordinate: coordinate)
            let model = mapper.map(dto: dto)

            cache.save(model)
            output?.didLoadWeather(model)

        } catch {
            if let cached = cache.load() {
                output?.didLoadWeather(cached)
            } else {
                output?.didFail(error)
            }
        }
    }
}
