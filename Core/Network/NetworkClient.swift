//
//  NetworkClient.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ url: URL) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {

    func request<T: Decodable>(_ url: URL) async throws -> T {

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw NetworkError.requestFailed
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
