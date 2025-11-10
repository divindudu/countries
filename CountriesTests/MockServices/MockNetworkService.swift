//
//  MockNetworkService.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation
@testable import Countries

// Mock Network Service pour tester le Repository
class MockNetworkService: NetworkServiceProtocol {
    var shouldFail: Bool
    var mockData: Data?
    var mockError: NetworkError?

    init(shouldFail: Bool = false, mockData: Data? = nil, mockError: NetworkError? = nil) {
        self.shouldFail = shouldFail
        self.mockData = mockData
        self.mockError = mockError
    }

    func fetch<T: Decodable>(from url: URL) async -> Result<T, NetworkError> {
        if shouldFail {
            return .failure(mockError ?? .networkError(NSError(domain: "MockError", code: -1)))
        }

        guard let data = mockData else {
            return .failure(.noData)
        }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
