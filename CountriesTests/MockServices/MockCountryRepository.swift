//
//  MockCountryRepository.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation
@testable import Countries

// Mock Repository pour les tests et previews
class MockCountryRepository: CountryRepositoryProtocol {
    var shouldFail: Bool
    var mockCountries: [Country]
    var delay: TimeInterval

    init(shouldFail: Bool = false, mockCountries: [Country] = [], delay: TimeInterval = 0) {
        self.shouldFail = shouldFail
        self.mockCountries = mockCountries
        self.delay = delay
    }

    func fetchAllCountries() async -> Result<[Country], NetworkError> {
        // Simuler un délai réseau si nécessaire
        if delay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }

        if shouldFail {
            return .failure(.networkError(NSError(domain: "MockError", code: -1)))
        }

        return .success(mockCountries)
    }
}
