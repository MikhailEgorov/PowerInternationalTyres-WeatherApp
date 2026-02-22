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
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let now = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        guard let nextHourDate = calendar.date(bySettingHour: minute > 0 ? hour + 1 : hour, minute: 0, second: 0, of: now) else {
            return WeatherDomainModel(locationName: dto.location.name,
                                      current: CurrentWeather(temperature: dto.current.temp_c, condition: dto.current.condition.text),
                                      hourly: [],
                                      forecast: [])
        }
        
        // HOURLY
        let hourly = dto.forecast.forecastday
            .flatMap { $0.hour }
            .compactMap { hour -> HourlyWeather? in
                guard let date = formatter.date(from: hour.time) else { return nil }
                return HourlyWeather(
                    date: date,
                    temperature: hour.temp_c
                )
            }
            .sorted { $0.date < $1.date }
            .filter { $0.date >= nextHourDate }
        
        // DAILY
        let dailyFormatter = DateFormatter()
        dailyFormatter.dateFormat = "yyyy-MM-dd"
        dailyFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let daily = dto.forecast.forecastday
            .sorted { $0.date < $1.date }
            .compactMap { day -> DailyWeather? in
                guard let date = dailyFormatter.date(from: day.date) else { return nil }
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
