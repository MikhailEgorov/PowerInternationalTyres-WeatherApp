//
//  WeatherAssembly.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class WeatherAssembly {

    static func assemble() -> UIViewController {

        let view = WeatherViewController()
        let network = NetworkClient()
        let service = WeatherService(network: network)
        let mapper = WeatherMapper()
        let location = LocationService()
        let cache = WeatherCacheService()

        let interactor = WeatherInteractor(
            service: service,
            mapper: mapper,
            locationService: location,
            cache: cache
        )

        let router = WeatherRouter()

        let presenter = WeatherPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        interactor.output = presenter

        return view
    }
}
