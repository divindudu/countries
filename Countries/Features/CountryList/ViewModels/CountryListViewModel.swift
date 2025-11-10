//
//  CountryListViewModel.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation
import Observation

enum LoadingState<T> {
    case idle
    case loading
    case success(T)
    case failure(NetworkError)
}

@MainActor
@Observable
class CountryListViewModel {
    private(set) var state: LoadingState<[Country]> = .idle

    private let repository: CountryRepositoryProtocol

    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }

    var countries: [Country] {
        if case .success(let countries) = state {
            return countries
        }
        return []
    }

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    var errorMessage: String? {
        if case .failure(let error) = state {
            return error.errorDescription
        }
        return nil
    }

    func loadCountries() async {
        state = .loading

        let result = await repository.fetchAllCountries()

        switch result {
        case .success(let countries):
            let sortedCountries = countries.sorted { $0.name < $1.name }

            state = .success(sortedCountries)
        case .failure(let error):
            state = .failure(error)
        }
    }

    func retry() async {
        await loadCountries()
    }
}
