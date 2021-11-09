//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 08.11.21.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUserName = "This username created an invalid request"
    case unableToComplete = "Unable to complete request. Please check internet connection"
    case invalidHTTPResponse = "Invalid response from server"
    case invalidData = "Invalid data received"
    case unableToParseData = "Error parsing data"

}
