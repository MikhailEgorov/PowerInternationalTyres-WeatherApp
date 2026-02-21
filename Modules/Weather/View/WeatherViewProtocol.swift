//
//  WeatherViewProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

protocol WeatherViewProtocol: AnyObject {
    func render(state: WeatherViewState)
}
