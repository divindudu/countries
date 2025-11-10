//
//  CountriesApp.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import SwiftUI

@main
struct CountriesApp: App {
    var body: some Scene {
        WindowGroup {
            CountryListView(
                viewModel: CountryListViewModel(
                    repository: CountryRepository(
                        networkService: NetworkService()
                    )
                )
            )
        }
    }
}
