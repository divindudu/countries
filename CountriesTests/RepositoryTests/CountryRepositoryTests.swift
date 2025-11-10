//
//  CountryRepositoryTests.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import XCTest
@testable import Countries

@MainActor
final class CountryRepositoryTests: XCTestCase {

    // MARK: - Test Successful Fetch

    func testFetchAllCountries_Success() async {
        // Given: Un network service mock avec des données valides
        let mockDTO = [
            CountryDTO(
                name: CountryDTO.NameDTO(common: "Canada", official: "Canada"),
                flags: CountryDTO.FlagsDTO(png: "https://test.com/ca.png", svg: nil, alt: nil),
                capital: ["Ottawa"],
                continents: ["North America"],
                population: 38_000_000
            )
        ]

        let encoder = JSONEncoder()
        let mockData = try! encoder.encode(mockDTO)

        let mockNetworkService = MockNetworkService(
            shouldFail: false,
            mockData: mockData
        )

        let repository = CountryRepository(networkService: mockNetworkService)

        // When: On récupère les pays
        let result = await repository.fetchAllCountries()

        // Then: Le résultat devrait être success avec les pays mappés
        switch result {
        case .success(let countries):
            XCTAssertEqual(countries.count, 1)
            XCTAssertEqual(countries.first?.name, "Canada")
            XCTAssertEqual(countries.first?.capital, "Ottawa")
            XCTAssertEqual(countries.first?.continent, "North America")
            XCTAssertEqual(countries.first?.population, 38_000_000)
        case .failure(let error):
            XCTFail("Expected success, got failure: \(error)")
        }
    }

    // MARK: - Test Network Failure

    func testFetchAllCountries_NetworkFailure() async {
        // Given: Un network service qui échoue
        let mockNetworkService = MockNetworkService(
            shouldFail: true,
            mockError: .networkError(NSError(domain: "Test", code: -1))
        )

        let repository = CountryRepository(networkService: mockNetworkService)

        // When: On récupère les pays
        let result = await repository.fetchAllCountries()

        // Then: Le résultat devrait être failure
        switch result {
        case .success:
            XCTFail("Expected failure, got success")
        case .failure(let error):
            if case .networkError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected networkError, got \(error)")
            }
        }
    }

    // MARK: - Test Decoding Error

    func testFetchAllCountries_DecodingError() async {
        // Given: Des données invalides
        let invalidData = "invalid json".data(using: .utf8)!

        let mockNetworkService = MockNetworkService(
            shouldFail: false,
            mockData: invalidData
        )

        let repository = CountryRepository(networkService: mockNetworkService)

        // When: On récupère les pays
        let result = await repository.fetchAllCountries()

        // Then: Le résultat devrait être failure avec decodingError
        switch result {
        case .success:
            XCTFail("Expected failure, got success")
        case .failure(let error):
            if case .decodingError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected decodingError, got \(error)")
            }
        }
    }

    // MARK: - Test DTO to Domain Mapping

    func testDTOToDomainMapping() {
        // Given: Un DTO
        let dto = CountryDTO(
            name: CountryDTO.NameDTO(common: "France", official: "French Republic"),
            flags: CountryDTO.FlagsDTO(png: "https://test.com/fr.png", svg: nil, alt: nil),
            capital: ["Paris"],
            continents: ["Europe"],
            population: 67_000_000
        )

        // When: On le convertit en modèle domaine
        let country = dto.toDomain()

        // Then: Les valeurs devraient être correctement mappées
        XCTAssertEqual(country.name, "France")
        XCTAssertEqual(country.flagURL, "https://test.com/fr.png")
        XCTAssertEqual(country.capital, "Paris")
        XCTAssertEqual(country.continent, "Europe")
        XCTAssertEqual(country.population, 67_000_000)
    }

    // MARK: - Test Missing Optional Fields

    func testDTOToDomainMapping_MissingOptionalFields() {
        // Given: Un DTO avec des champs optionnels manquants
        let dto = CountryDTO(
            name: CountryDTO.NameDTO(common: "Antarctica", official: nil),
            flags: CountryDTO.FlagsDTO(png: "https://test.com/aq.png", svg: nil, alt: nil),
            capital: nil, // Pas de capitale
            continents: nil, // Pas de continent spécifié
            population: nil // Pas de population
        )

        // When: On le convertit en modèle domaine
        let country = dto.toDomain()

        // Then: Les valeurs par défaut devraient être utilisées
        XCTAssertEqual(country.name, "Antarctica")
        XCTAssertEqual(country.capital, "N/A")
        XCTAssertEqual(country.continent, "N/A")
        XCTAssertEqual(country.population, 0)
    }

    // MARK: - Test Formatted Population

    func testFormattedPopulation() {
        // Given: Un pays avec une grande population
        let country = Country(
            name: "Test Country",
            flagURL: "https://test.com",
            capital: "Test",
            continent: "Test",
            population: 123_456_789
        )

        // When: On récupère la population formatée
        let formatted = country.formattedPopulation

        // Then: Elle devrait être formatée avec des espaces
        XCTAssertTrue(formatted.contains("123"))
        XCTAssertTrue(formatted.contains("456"))
        XCTAssertTrue(formatted.contains("789"))
    }
}
