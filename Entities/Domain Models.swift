//
//  Domain Models.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

struct WeatherDomainModel {
    let locationName: String
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let forecast: [DailyWeather]
}

struct CurrentWeather {
    let temperature: Double
    let conditionText: String
    let iconURL: URL?
}

struct HourlyWeather {
    let date: Date
    let temperature: Double
    let conditionText: String
    let iconURL: URL?
}

struct DailyWeather {
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let conditionText: String
    let iconURL: URL?
}
