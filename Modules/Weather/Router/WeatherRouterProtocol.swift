//
//  WeatherRouterProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

protocol WeatherRouterProtocol: AnyObject {
    func showErrorAlert(on view: UIViewController, message: String)
}
