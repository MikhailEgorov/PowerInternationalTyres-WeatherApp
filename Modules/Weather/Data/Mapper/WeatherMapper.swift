//
//  WeatherMapper.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

final class WeatherMapper: WeatherMapperProtocol {

    func map(dto: ForecastResponseDTO) -> WeatherDomainModel {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let hourly = dto.forecast.forecastday.flatMap { day in
            day.hour.compactMap { hour -> HourlyWeather? in
                guard let date = formatter.date(from: hour.time) else { return nil }
                return HourlyWeather(date: date, temperature: hour.temp_c)
            }
        }

        let daily = dto.forecast.forecastday.compactMap { day -> DailyWeather? in
            guard let date = ISO8601DateFormatter().date(from: day.date + "T00:00:00Z")
            else { return nil }

            return DailyWeather(
                date: date,
                minTemp: day.day.mintemp_c,
                maxTemp: day.day.maxtemp_c
            )
        }

        return WeatherDomainModel(
            locationName: dto.location.name,
            current: CurrentWeather(
                temperature: dto.current.temp_c,
                condition: dto.current.condition.text
            ),
            hourly: hourly,
            forecast: daily
        )
    }
}
