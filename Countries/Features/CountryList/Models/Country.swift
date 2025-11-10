//
//  Country.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation

struct Country: Identifiable, Equatable, Sendable {
    let id = UUID()
    let name: String
    let flagURL: String
    let capital: String
    let continent: String
    let population: Int

    var formattedPopulation: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: population)) ?? "\(population)"
    }
}

// Mock data pour les previews et tests
extension Country {
    static let mock = Country(
        name: "Canada",
        flagURL: "https://flagcdn.com/w320/ca.png",
        capital: "Ottawa",
        continent: "North America",
        population: 38_000_000
    )

    static let mockList = [
        Country(name: "Canada", flagURL: "https://flagcdn.com/w320/ca.png", capital: "Ottawa", continent: "North America", population: 38_000_000),
        Country(name: "France", flagURL: "https://flagcdn.com/w320/fr.png", capital: "Paris", continent: "Europe", population: 67_000_000),
        Country(name: "Japan", flagURL: "https://flagcdn.com/w320/jp.png", capital: "Tokyo", continent: "Asia", population: 125_000_000)
    ]
}
