//
//  ViewModel.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

struct WeatherViewModel {

    let locationTitle: String
    let current: CurrentSectionViewModel
    let hourly: [HourlyItemViewModel]
    let forecast: [ForecastItemViewModel]
}

struct CurrentSectionViewModel: Hashable, Sendable {
    let temperatureText: String
    let conditionText: String
}

struct HourlyItemViewModel: Hashable, Sendable {
    let timeText: String
    let temperatureText: String
}

struct ForecastItemViewModel: Hashable, Sendable {
    let dayText: String
    let minMaxText: String
}
