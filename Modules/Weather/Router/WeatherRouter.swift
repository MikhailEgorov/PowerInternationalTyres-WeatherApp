//
//  WeatherRouter.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class WeatherRouter: WeatherRouterProtocol {

    func showErrorAlert(on view: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        view.present(alert, animated: true)
    }
}
