//
//  WeatherCacheProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

protocol WeatherCacheProtocol {
    func save(_ model: WeatherDomainModel)
    func load() -> WeatherDomainModel?
}
