//
//  CountryDetailView.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AsyncImage(url: URL(string: country.flagURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {
                    CountryDetailRowView(
                        icon: "building.columns",
                        title: "Capitale",
                        value: country.capital
                    )

                    CountryDetailRowView(
                        icon: "globe",
                        title: "Continent",
                        value: country.continent
                    )

                    CountryDetailRowView(
                        icon: "person.3",
                        title: "Population",
                        value: country.formattedPopulation
                    )
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CountryDetailView(country: .mock)
    }
}
