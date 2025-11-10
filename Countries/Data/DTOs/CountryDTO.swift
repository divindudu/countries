//
//  CountryDTO.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation

// DTO (Data Transfer Object) - Représente exactement la structure JSON de l'API
struct CountryDTO: Codable {
    let name: NameDTO
    let flags: FlagsDTO
    let capital: [String]?
    let continents: [String]?
    let population: Int?

    struct NameDTO: Codable {
        let common: String
        let official: String?
    }

    struct FlagsDTO: Codable {
        let png: String
        let svg: String?
        let alt: String?
    }
}

// Extension pour mapper le DTO vers le modèle du domaine
extension CountryDTO {
    func toDomain() -> Country {
        Country(
            name: name.common,
            flagURL: flags.png,
            capital: capital?.first ?? "N/A",
            continent: continents?.first ?? "N/A",
            population: population ?? 0
        )
    }
}
