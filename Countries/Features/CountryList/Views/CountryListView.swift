//
//  CountryListView.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import SwiftUI
import Foundation

struct CountryListView: View {

    @State var viewModel: CountryListViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle:
                    Color.clear
                        .onAppear {
                            Task {
                                await viewModel.loadCountries()
                            }
                        }

                case .loading:
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Chargement des pays...")
                            .foregroundColor(.secondary)
                    }

                case .success(let countries):
                    List(countries) { country in
                        NavigationLink {
                            CountryDetailView(country: country)
                        } label: {
                            CountryRowView(country: country)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadCountries()
                    }

                case .failure(let error):
                    ErrorView(
                        error: error,
                        retryAction: {
                            Task {
                                await viewModel.retry()
                            }
                        }
                    )
                }
            }
            .navigationTitle("Pays du monde")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Preview - Mock simple pour les previews
private class PreviewCountryRepository: CountryRepositoryProtocol {
    let shouldFail: Bool
    let mockCountries: [Country]

    init(shouldFail: Bool = false, mockCountries: [Country] = []) {
        self.shouldFail = shouldFail
        self.mockCountries = mockCountries
    }

    func fetchAllCountries() async -> Result<[Country], NetworkError> {
        if shouldFail {
            return .failure(.networkError(NSError(domain: "Preview", code: -1)))
        }
        return .success(mockCountries)
    }
}

#Preview("Success") {
    CountryListView(
        viewModel: CountryListViewModel(
            repository: PreviewCountryRepository(
                shouldFail: false,
                mockCountries: Country.mockList
            )
        )
    )
}

#Preview("Error") {
    CountryListView(
        viewModel: CountryListViewModel(
            repository: PreviewCountryRepository(
                shouldFail: true,
                mockCountries: []
            )
        )
    )
}
