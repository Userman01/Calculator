//
//  CalculatorFormatterExtension.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import Foundation

extension String {

    func separateResult() -> SeparatedMathExpression {
        let equalsSeparator = "="
        if self.contains(equalsSeparator) {
            let parts = self.components(separatedBy: equalsSeparator)
            let expressionPart = parts[safe: 0] ?? ""
            let equalsPart = parts[safe: 1] ?? ""
            return SeparatedMathExpression(expressionPart: expressionPart, equalsPart: equalsSeparator + equalsPart)
        } else {
            return SeparatedMathExpression(expressionPart: self)
        }
    }

    func toFormattedExpressionNumber() -> String? {
        let componentsSeparator = "\u{00a0}"
        if self.contains(componentsSeparator) {
            var components = self.components(separatedBy: componentsSeparator)
            for i in components.indices {
                if components[i].toNumber() != nil {
                   components[i] = formattedNumberBySpace(components[i])
                }
            }
            return components.joined(separator: "\u{00a0}")
        } else {
            return formattedNumberBySpace(self)
        }
    }

    func toFormattedForMathExpression() -> String {
        let equalsSeparator = "="
        let opertors = "/*+-."
        var text = self.replacingOccurrences(of: "\u{00a0}", with: "")
            .replacingOccurrences(of: "q", with: "")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: ",", with: ".")
        if self.contains(equalsSeparator) {
            let parts = text.components(separatedBy: equalsSeparator)
            var expressionPart = parts[safe: 0] ?? ""
            if let lastCharacter = expressionPart.last, opertors.contains(lastCharacter) {
                expressionPart.removeLast()
            }
            return expressionPart
        } else {
            if let lastCharacter = text.last, opertors.contains(lastCharacter) {
                text.removeLast()
            }
            return text
        }
    }

    func toFormattedTextMathExpression() -> String {
        let equalsSeparator = "="
        let text = self.replacingOccurrences(of: "q", with: "")
        if self.contains(equalsSeparator) {
            let parts = text.components(separatedBy: equalsSeparator)
            return parts[safe: 0] ?? ""
        }
        return text
    }

    func toRemoveCharacter(_ character: String) -> String {
        let text = self.replacingOccurrences(of: character, with: "")
        return text
    }

    func isExpressionContainsOperators() -> Bool {
        let opertors = "÷×+-"
        return opertors.contains {
            self.contains($0)
        }
    }

    private func formattedNumberBySpace(_ text: String) -> String {
        var result: String
        if text.contains(",") {
            let parts = text.components(separatedBy: ",")
            let integerPart = parts[safe: 0] ?? ""
            let decimalPart = parts[safe: 1] ?? ""
            let integerText = integerPart.toFormattedAmount(minimumFractionDigits: 0) ?? ""
            result = integerText + "," + decimalPart
        } else {
            result = text.toFormattedAmount(minimumFractionDigits: 0) ?? text
        }
        return result
    }
}

extension NSNumber {

    func toFormattedResultMathExpression() -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        return formatter.string(for: self.decimalValue)?
            .replacingOccurrences(of: ".", with: ",")
    }
}
