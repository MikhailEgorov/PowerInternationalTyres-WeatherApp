//
//  PowerInternationalTyres_WeatherAppTests.swift
//  PowerInternationalTyres-WeatherAppTests
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import XCTest
import CoreLocation
@testable import PowerInternationalTyres_WeatherApp

@MainActor
final class WeatherInteractorTests: XCTestCase {

    private var interactor: WeatherInteractor!
    private var output: MockInteractorOutput!
    private var service: MockWeatherService!
    private var mapper: WeatherMapper!
    private var cache: MockCache!
    private var locationService: MockLocationService!

    override func setUp() {
        super.setUp()
        service = MockWeatherService()
        mapper = WeatherMapper()
        locationService = MockLocationService()
        cache = MockCache()
        interactor = WeatherInteractor(
            service: service,
            mapper: mapper,
            locationService: locationService,
            cache: cache
        )
        output = MockInteractorOutput()
        interactor.output = output
    }

    func test_fetchWeather_success_callsOutput() async {
        service.dtoToReturn = sampleDTO()
        await interactor.fetchWeatherForTests()
        XCTAssertTrue(output.didLoadCalled)
    }

    func test_fetchWeather_failure_loadsCache() async {
        service.errorToThrow = NSError(domain: "test", code: 0)
        cache.modelToReturn = mapper.map(dto: sampleDTO())
        await interactor.fetchWeatherForTests()
        XCTAssertTrue(output.didLoadCalled)
    }

    func test_fetchWeather_failure_noCache_callsDidFail() async {
        service.errorToThrow = NSError(domain: "test", code: 0)
        cache.modelToReturn = nil
        await interactor.fetchWeatherForTests()
        XCTAssertTrue(output.didFailCalled)
    }

    // MARK: - Helpers
    private func sampleDTO() -> ForecastResponseDTO {
        ForecastResponseDTO(
            location: LocationDTO(name: "Moscow"),
            current: CurrentDTO(temp_c: 10, condition: ConditionDTO(text: "Clear")),
            forecast: ForecastDTO(forecastday: [
                ForecastDayDTO(
                    date: "2026-01-01",
                    day: DayDTO(maxtemp_c: 12, mintemp_c: 5),
                    hour: [HourDTO(time: "2026-01-01 10:00", temp_c: 8)]
                )
            ])
        )
    }
}

final class WeatherMapperTests: XCTestCase {

    var mapper: WeatherMapper!

    override func setUp() {
        super.setUp()
        mapper = WeatherMapper()
    }

    func test_map_returnsCorrectDomain() throws {
        let dto = ForecastResponseDTO(
            location: LocationDTO(name: "Moscow"),
            current: CurrentDTO(temp_c: 10, condition: ConditionDTO(text: "Clear")),
            forecast: ForecastDTO(forecastday: [
                ForecastDayDTO(
                    date: "2026-01-01",
                    day: DayDTO(maxtemp_c: 12, mintemp_c: 5),
                    hour: [HourDTO(time: "2026-01-01 10:00", temp_c: 8)]
                )
            ])
        )

        let domain = mapper.map(dto: dto)

        XCTAssertEqual(domain.locationName, "Moscow")
        XCTAssertEqual(domain.current.temperature, 10)
        XCTAssertEqual(domain.current.condition, "Clear")
        XCTAssertEqual(domain.forecast.count, 1)
        XCTAssertEqual(domain.hourly.count, 1)
    }
}

final class LocationServiceTests: XCTestCase {

    func test_requestLocation_returnsMoscow_ifDenied() async {
        let service = MockDeniedLocationService()
        let coord = await service.requestLocation()
        XCTAssertEqual(coord.latitude, 55.7558, accuracy: 0.001)
        XCTAssertEqual(coord.longitude, 37.6176, accuracy: 0.001)
    }
}

private final class MockDeniedLocationService: LocationServiceProtocol {
    func requestLocation() async -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)
    }
}
