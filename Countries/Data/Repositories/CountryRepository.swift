//
//  CountryRepository.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation

class CountryRepository: CountryRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://restcountries.com/v3.1"

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchAllCountries() async -> Result<[Country], NetworkError> {
        let urlString = "\(baseURL)/all?fields=name,flags,capital,continents,population"

        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }

        let result: Result<[CountryDTO], NetworkError> = await networkService.fetch(from: url)

        // Mapper les DTOs vers les modèles du domaine
        switch result {
        case .success(let dtos):
            let countries = dtos.map { $0.toDomain() }
            return .success(countries)
        case .failure(let error):
            return .failure(error)
        }
    }
}
