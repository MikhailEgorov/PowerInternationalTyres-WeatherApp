//
//  WeatherViewController.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

enum WeatherViewState {
    case loading
    case content(WeatherViewModel)
    case error(String)
}

final class WeatherViewController: UIViewController, WeatherViewProtocol {

    var presenter: WeatherPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    func render(state: WeatherViewState) {
        // позже реализуем
    }
}
