//
//  CountryListViewModelTests.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import XCTest
@testable import Countries

@MainActor
final class CountryListViewModelTests: XCTestCase {

    // MARK: - Test Loading Success

    func testLoadCountries_Success() async {
        // Given: Un repository mock qui retourne des pays
        let mockCountries = [
            Country(name: "Canada", flagURL: "https://test.com/ca.png", capital: "Ottawa", continent: "North America", population: 38_000_000),
            Country(name: "France", flagURL: "https://test.com/fr.png", capital: "Paris", continent: "Europe", population: 67_000_000),
            Country(name: "Japan", flagURL: "https://test.com/jp.png", capital: "Tokyo", continent: "Asia", population: 125_000_000)
        ]
        let mockRepository = MockCountryRepository(
            shouldFail: false,
            mockCountries: mockCountries
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // When: On charge les pays
        await viewModel.loadCountries()

        // Then: L'état devrait être success avec les pays triés
        if case .success(let countries) = viewModel.state {
            XCTAssertEqual(countries.count, mockCountries.count)
            // Vérifier que les pays sont triés par nom
            XCTAssertEqual(countries.first?.name, "Canada")
            XCTAssertEqual(countries.last?.name, "Japan")
        } else {
            XCTFail("Expected success state")
        }
    }

    // MARK: - Test Loading Failure

    func testLoadCountries_Failure() async {
        // Given: Un repository mock qui échoue
        let mockRepository = MockCountryRepository(
            shouldFail: true,
            mockCountries: []
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // When: On charge les pays
        await viewModel.loadCountries()

        // Then: L'état devrait être failure
        if case .failure(let error) = viewModel.state {
            XCTAssertNotNil(error.errorDescription)
        } else {
            XCTFail("Expected failure state")
        }
    }

    // MARK: - Test Loading State

    func testLoadCountries_LoadingState() async {
        // Given: Un repository mock avec un délai
        let mockCountries = [
            Country(name: "Test", flagURL: "https://test.com", capital: "Test", continent: "Test", population: 1000)
        ]
        let mockRepository = MockCountryRepository(
            shouldFail: false,
            mockCountries: mockCountries,
            delay: 0.1
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // When: On démarre le chargement
        let loadTask = Task {
            await viewModel.loadCountries()
        }

        // Attendre un peu pour vérifier l'état de chargement
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 secondes

        // Then: L'état devrait être loading
        XCTAssertTrue(viewModel.isLoading)

        // Attendre la fin du chargement
        await loadTask.value

        // Then: L'état ne devrait plus être loading
        XCTAssertFalse(viewModel.isLoading)
    }

    // MARK: - Test Initial State

    func testInitialState() async {
        // Given: Un nouveau ViewModel
        let mockRepository = MockCountryRepository(
            shouldFail: false,
            mockCountries: []
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // Then: L'état initial devrait être idle
        if case .idle = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected idle state")
        }
    }

    // MARK: - Test Retry

    func testRetry_AfterFailure() async {
        // Given: Un repository qui échoue initialement
        let mockRepository = MockCountryRepository(
            shouldFail: true,
            mockCountries: []
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // When: Premier chargement échoue
        await viewModel.loadCountries()

        // Then: État devrait être failure
        if case .failure = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failure state")
        }

        // When: On corrige le repository et on réessaie
        mockRepository.shouldFail = false
        mockRepository.mockCountries = [
            Country(name: "Test", flagURL: "https://test.com", capital: "Test", continent: "Test", population: 1000)
        ]
        await viewModel.retry()

        // Then: État devrait être success
        if case .success(let countries) = viewModel.state {
            XCTAssertEqual(countries.count, 1)
        } else {
            XCTFail("Expected success state after retry")
        }
    }

    // MARK: - Test Computed Properties

    func testCountriesProperty() async {
        // Given: Un repository avec des pays
        let mockCountries = [
            Country(name: "Test1", flagURL: "https://test.com", capital: "Test", continent: "Test", population: 1000),
            Country(name: "Test2", flagURL: "https://test.com", capital: "Test", continent: "Test", population: 2000)
        ]
        let mockRepository = MockCountryRepository(
            shouldFail: false,
            mockCountries: mockCountries
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // When: On charge les pays
        await viewModel.loadCountries()

        // Then: La propriété countries devrait retourner les pays
        XCTAssertEqual(viewModel.countries.count, mockCountries.count)
    }

    func testErrorMessageProperty() async {
        // Given: Un repository qui échoue
        let mockRepository = MockCountryRepository(
            shouldFail: true,
            mockCountries: []
        )
        let viewModel = CountryListViewModel(repository: mockRepository)

        // When: On charge les pays
        await viewModel.loadCountries()

        // Then: errorMessage devrait contenir un message
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.errorMessage!.isEmpty)
    }
}
