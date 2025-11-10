//
//  CountryRowView.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import SwiftUI

struct CountryRowView: View {
    let country: Country

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: country.flagURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 40)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                case .failure:
                    Image(systemName: "photo")
                        .frame(width: 60, height: 40)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                @unknown default:
                    EmptyView()
                }
            }

            Text(country.name)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        CountryRowView(country: .mock)
        CountryRowView(country: Country.mockList[1])
        CountryRowView(country: Country.mockList[2])
    }
}
