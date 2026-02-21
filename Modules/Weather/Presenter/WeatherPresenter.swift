//
//  WeatherPresenter.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class WeatherPresenter: WeatherPresenterProtocol {

    weak var view: WeatherViewProtocol?
    private let interactor: WeatherInteractorProtocol
    private let router: WeatherRouterProtocol

    init(view: WeatherViewProtocol,
         interactor: WeatherInteractorProtocol,
         router: WeatherRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.render(state: .loading)
        interactor.loadWeather()
    }

    func didPullToRefresh() {
        interactor.refresh()
    }
}

extension WeatherPresenter: WeatherInteractorOutput {

    func didLoadWeather(_ model: WeatherDomainModel) {

        let viewModel = WeatherViewModel(
            locationTitle: model.locationName,

            current: CurrentSectionViewModel(
                temperatureText: "\(Int(model.current.temperature))°",
                conditionText: model.current.condition
            ),

            hourly: model.hourly.map {
                HourlyItemViewModel(
                    timeText: $0.date.formatted(date: .omitted, time: .shortened),
                    temperatureText: "\(Int($0.temperature))°"
                )
            },

            forecast: model.forecast.map {
                ForecastItemViewModel(
                    dayText: $0.date.formatted(date: .abbreviated, time: .omitted),
                    minMaxText: "мин \(Int($0.minTemp))° / макс \(Int($0.maxTemp))°"
                )
            }
        )

        view?.render(state: .content(viewModel))
    }

    func didFail(_ error: Error) {
        guard let viewController = view as? UIViewController else { return }
        router.showErrorAlert(
            on: viewController,
            message: error.localizedDescription
        )
    }
}
