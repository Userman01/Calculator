//
//  CalculatorWorker.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import Foundation

protocol CalculatorWorkerDelegate: AnyObject {

    func getCalculateResult(_ text: String) throws -> String

    func getMathResult(_ text: String) throws -> String
}

final class CalculatorWorker: CalculatorWorkerDelegate {

    func getCalculateResult(_ text: String) throws -> String {
        if text.contains("q") {
            do {
                return try calculationLogic(text)
            } catch let error {
                throw error
            }
        } else {
            return fastCalculationLogic(text)
        }
    }

    func getMathResult(_ text: String) throws -> String {
        do {
            return try calculationLogic(text)
        } catch let error {
            throw error
        }
    }
}

extension CalculatorWorker {

    private func calculationLogic(_ text: String) throws -> String {
        let textMath = text.toFormattedForMathExpression()
        guard !textMath.isEmpty else { return textMath }
        let expression = NSExpression(format: textMath)
        if let resultMath = expression.toFloatingPoint().expressionValue(with: nil, context: nil) as? NSNumber,
           resultMath.decimalValue >= 0,
           !resultMath.decimalValue.isInfinite {
            return resultMath.toFormattedResultMathExpression() ?? ""
        } else if let resultMath = expression.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double, resultMath < 0 {
            throw ValidationError(R.string.localizable.calculatorErrorANegativeNumber())
        } else {
            throw ValidationError(R.string.localizable.calculatorErrorImpossibleToCount())
        }
    }

    private func fastCalculationLogic(_ text: String) -> String {
        if text.isExpressionContainsOperators() {
            let text = text.toFormattedTextMathExpression()
            var resultMath: String = ""
            do {
                resultMath = try calculationLogic(text)
                return text + "\u{003D}" + resultMath
            } catch {
                return text
            }
        } else {
            return text.toFormattedTextMathExpression()
        }
    }
}
