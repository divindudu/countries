//
//  CountryDetailView.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import SwiftUI

enum CountryDetailRow: CaseIterable {
    case capital
    case continent
    case population

    var icon: String {
        switch self {
            case .capital: return "building.columns"
            case .continent: return "globe"
            case .population: return "person.3"
        }
    }

    var title: String {
        switch self {
            case .capital: return "Capital"
            case .continent: return "Continent"
            case .population: return "Population"
        }
    }

    func value(for country: Country) -> String {
        switch self {
            case .capital: return country.capital
            case .continent: return country.continent
            case .population: return country.formattedPopulation
        }
    }
}

struct CountryDetailView: View {
    let country: Country
    let transitionNamespace: Namespace.ID

    @State private var visibleRows: [CountryDetailRow] = []

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
                            .aspectRatio(contentMode: .fit)
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
                    ForEach(CountryDetailRow.allCases, id: \.self) { row in
                        if visibleRows.contains(row) {
                            CountryDetailRowView(icon: row.icon, title: row.title, value: row.value(for: country))
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationTransition(.zoom(sourceID: country.id, in: transitionNamespace))
        .task {
            for (index, row) in CountryDetailRow.allCases.enumerated() {
                withAnimation(.easeIn(duration: 0.3).delay(Double(index) * 0.15)) {
                    visibleRows.insert(row, at: index)
                }
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var transitionNamespace
    NavigationStack {
        CountryDetailView(country: .mock, transitionNamespace: transitionNamespace)
    }
}
