//
//  HourlyFilter.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

struct HourlyFilter {

    static func filter(
        from hourly: [HourlyWeather],
        now: Date,
        calendar: Calendar = .current
    ) -> [HourlyWeather] {

        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else {
            return []
        }

        return hourly.filter {
            let date = $0.date

            let isToday = calendar.isDate(date, inSameDayAs: now)
            let isTomorrow = calendar.isDate(date, inSameDayAs: tomorrow)

            if isToday {
                return date >= now
            }

            if isTomorrow {
                return true
            }

            return false
        }
        .sorted { $0.date < $1.date }
    }
}
