//
//  WeatherPresenter.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

final class WeatherPresenter: WeatherPresenterProtocol {

    weak var view: WeatherViewProtocol?
    var interactor: WeatherInteractorProtocol!
    var router: WeatherRouterProtocol!

    func viewDidLoad() {
        view?.render(state: .loading)
        Task {
            await interactor.fetchWeather(forceRefresh: false)
        }
    }

    func didPullToRefresh() {
        Task {
            await interactor.fetchWeather(forceRefresh: true)
        }
    }
}
