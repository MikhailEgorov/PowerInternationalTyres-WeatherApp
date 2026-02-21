//
//  DTO.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

struct ForecastResponseDTO: Decodable {
    let location: LocationDTO
    let current: CurrentDTO
    let forecast: ForecastDTO
}

struct LocationDTO: Decodable {
    let name: String
    let localtime: String
}

struct CurrentDTO: Decodable {
    let temp_c: Double
    let condition: ConditionDTO
}

struct ForecastDTO: Decodable {
    let forecastday: [ForecastDayDTO]
}

struct ForecastDayDTO: Decodable {
    let date: String
    let day: DayDTO
    let hour: [HourDTO]
}

struct DayDTO: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: ConditionDTO
}

struct HourDTO: Decodable {
    let time: String
    let temp_c: Double
    let condition: ConditionDTO
}

struct ConditionDTO: Decodable {
    let text: String
    let icon: String
}
