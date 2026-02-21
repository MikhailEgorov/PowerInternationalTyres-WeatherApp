//
//  WeatherInteractorOutput.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

protocol WeatherInteractorOutput: AnyObject {
    func didLoadWeather(_ model: WeatherDomainModel)
    func didFail(_ error: Error)
}
