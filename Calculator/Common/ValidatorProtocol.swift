//
//  ValidatorProtocol.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

protocol ValidatorProtocol {
    func validated(_ value: String) throws -> String
    func isValid(_ value: String) -> Bool
}

extension ValidatorProtocol {

    func isValid(_ value: String) -> Bool {
        do {
            _ = try validated(value)
        } catch {
            return false
        }
        return true
    }
}
