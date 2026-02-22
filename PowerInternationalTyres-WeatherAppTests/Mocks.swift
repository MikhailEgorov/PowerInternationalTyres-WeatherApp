//
//  Mocks.swift
//  PowerInternationalTyres-WeatherAppTests
//
//  Created by Mikhail Egorov on 21.02.2026.
//
import Foundation
import CoreLocation
@testable import PowerInternationalTyres_WeatherApp

final class MockWeatherService: WeatherServiceProtocol {
    var dtoToReturn: ForecastResponseDTO?
    var errorToThrow: Error?

    func fetchWeather(coordinate: CLLocationCoordinate2D) async throws -> ForecastResponseDTO {
        if let error = errorToThrow { throw error }
        guard let dto = dtoToReturn else {
            throw NSError(domain: "MockWeatherService", code: 0)
        }
        return dto
    }
}

final class MockCache: WeatherCacheProtocol {
    var modelToReturn: WeatherDomainModel?

    func save(_ model: WeatherDomainModel) {
        
    }

    func load() -> WeatherDomainModel? {
        return modelToReturn
    }
}

final class MockLocationService: LocationServiceProtocol {
    func requestLocation() async -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 55.75, longitude: 37.61)
    }
}

final class MockInteractorOutput: WeatherInteractorOutput {
    var didLoadCalled = false
    var didFailCalled = false

    func didLoadWeather(_ weather: WeatherDomainModel) {
        didLoadCalled = true
    }

    func didFail(_ error: Error) {
        didFailCalled = true
    }
}
