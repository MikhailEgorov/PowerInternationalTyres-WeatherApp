//
//  WeatherAssembly.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class WeatherAssembly {
    
    static func build() -> UIViewController {
        
        let view = WeatherViewController()
        let presenter = WeatherPresenter()
        let interactor = WeatherInteractor()
        let router = WeatherRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        return view
    }
}
