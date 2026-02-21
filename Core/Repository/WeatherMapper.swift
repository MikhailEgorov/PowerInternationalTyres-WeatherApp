//
//  WeatherMapper.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

protocol WeatherMapperProtocol {
    func map(from dto: ForecastResponseDTO) throws -> WeatherDomainModel
}

final class WeatherMapper: WeatherMapperProtocol {

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func map(from dto: ForecastResponseDTO) throws -> WeatherDomainModel {

        let current = CurrentWeather(
            temperature: dto.current.temp_c,
            conditionText: dto.current.condition.text,
            iconURL: URL(string: "https:\(dto.current.condition.icon)")
        )

        let daily: [DailyWeather] = dto.forecast.forecastday.compactMap { day in
            guard let date = dayFormatter.date(from: day.date) else { return nil }
            return DailyWeather(
                date: date,
                minTemp: day.day.mintemp_c,
                maxTemp: day.day.maxtemp_c,
                conditionText: day.day.condition.text,
                iconURL: URL(string: "https:\(day.day.condition.icon)")
            )
        }

        let hourly: [HourlyWeather] = dto.forecast.forecastday.flatMap { day in
            day.hour.compactMap { hour in
                guard let date = dateFormatter.date(from: hour.time) else { return nil }
                return HourlyWeather(
                    date: date,
                    temperature: hour.temp_c,
                    conditionText: hour.condition.text,
                    iconURL: URL(string: "https:\(hour.condition.icon)")
                )
            }
        }

        return WeatherDomainModel(
            locationName: dto.location.name,
            current: current,
            hourly: hourly,
            forecast: daily
        )
    }
}
