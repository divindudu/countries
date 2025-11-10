//
//  NetworkService.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from url: URL) async -> Result<T, NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(from url: URL) async -> Result<T, NetworkError> {
        do {
            let (data, response) = try await session.data(from: url)

            // Vérifier le statut HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknown)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.serverError(httpResponse.statusCode))
            }

            // Décoder les données
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingError(error))
            }

        } catch {
            return .failure(.networkError(error))
        }
    }
}
