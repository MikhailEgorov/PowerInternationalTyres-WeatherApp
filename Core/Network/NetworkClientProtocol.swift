//
//  NetworkClientProtocol.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(url: URL) async throws -> T
}
