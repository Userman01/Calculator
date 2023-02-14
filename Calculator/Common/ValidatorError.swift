//
//  ValidatorError.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

final class ValidationError: Error {

    let message: String

    init(_ message: String = "") {
        self.message = message
    }
}
