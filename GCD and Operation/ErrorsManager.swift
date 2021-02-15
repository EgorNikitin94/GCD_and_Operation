//
//  ErrorsManager.swift
//  GCD and Operation
//
//  Created by Егор Никитин on 11.02.2021.
//

import Foundation

enum AppErrors: LocalizedError {
    
    case noInternetConnection
    case notFoundURLs
    case invalidModel
    case notImageURL
    
    var errorDescription: String? {
        switch self {
        case .noInternetConnection, .notFoundURLs:
            return "We have some problems with our server"
        case .invalidModel:
            return "We have some problems with data parsing"
        case.notImageURL:
            return "We have't URL for image in cell"
        }
    }

}
