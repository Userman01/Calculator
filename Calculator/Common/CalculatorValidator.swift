//
//  CalculatorValidator.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import Foundation

struct CalculatorValidator: ValidatorProtocol {
    func validated(_ value: String) throws -> String {
        if let errorText = getErrorText(value) {
            throw ValidationError(errorText)
        }
        return value
    }

    private func getErrorText(_ value: String) -> String? {
        if isMatches(for: ",,", in: value) {
            return R.string.localizable.calculatorErrorImpossibleToCount()
        }
        if isMatches(for: ",\\d\\d\\d", in: value) {
            return R.string.localizable.calculatorErrorDecimalCount()
        }
        if isMatches(for: "[÷×+-][÷×+-]", in: value) {
            return R.string.localizable.calculatorErrorImpossibleToCount()
        }
        if isDoublePoint(in: value) {
            return R.string.localizable.calculatorErrorImpossibleToCount()
        }
        return nil
    }

    private func isMatches(for regex: String, in text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            if regex.numberOfMatches(in: text, range: NSRange(text.startIndex..., in: text)) > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    private func isDoublePoint(in text: String) -> Bool {
        let componentsSeparator = "\u{00a0}"
        let opertor = ","
        if text.contains(componentsSeparator) {
            let components = text.components(separatedBy: componentsSeparator)
            for i in components.indices {
                if components[i].contains(opertor) {
                    var countPoint: Int = 0
                    components[i].forEach {
                        if String($0) == opertor {
                            countPoint += 1
                        }
                    }
                    if countPoint > 1 {
                        return true
                    }
                }
            }
        }
        return false
    }
}
