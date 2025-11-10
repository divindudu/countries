//
//  NetworkError.swift
//  Countries
//
//  Created by Jean-François Duval on 2025-11-10.
//  Copyright © 2025 Jean-François Duval. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case networkError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "L'URL de la requête est invalide."
        case .noData:
            return "Aucune donnée reçue du serveur."
        case .decodingError(let error):
            return "Erreur lors du décodage des données: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Erreur du serveur (code \(statusCode))."
        case .networkError(let error):
            return "Erreur réseau: \(error.localizedDescription)"
        case .unknown:
            return "Une erreur inconnue s'est produite."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Veuillez vérifier l'URL et réessayer."
        case .noData:
            return "Veuillez vérifier votre connexion Internet."
        case .decodingError:
            return "Les données reçues sont invalides."
        case .serverError:
            return "Le serveur rencontre un problème. Réessayez plus tard."
        case .networkError:
            return "Vérifiez votre connexion Internet et réessayez."
        case .unknown:
            return "Veuillez réessayer."
        }
    }
}
