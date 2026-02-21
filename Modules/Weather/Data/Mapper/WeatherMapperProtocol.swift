//
//  WeatherMapperProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

protocol WeatherMapperProtocol {
    func map(dto: ForecastResponseDTO) -> WeatherDomainModel
}
