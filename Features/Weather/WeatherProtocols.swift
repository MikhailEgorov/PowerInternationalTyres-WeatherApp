//
//  WeatherProtocols.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation


protocol WeatherViewProtocol: AnyObject {
    func render(state: WeatherViewState)
}

protocol WeatherPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didPullToRefresh()
}

protocol WeatherInteractorProtocol: AnyObject {
    func fetchWeather(forceRefresh: Bool) async
}

protocol WeatherInteractorOutput: AnyObject {
    func didLoadWeather(_ weather: WeatherDomainModel)
    func didFail(with error: Error)
}

protocol WeatherRouterProtocol: AnyObject {
}
