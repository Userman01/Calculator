//
//  CalculatorFormatter.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class CalculatorFormatter: Formatter {

    private enum ViewMetrics {
        static let expressionColor: UIColor! = .textPrimaryColor
        static let equelsColor: UIColor! = .textSecondaryColor
    }

    private let allowedChars = "0123456789÷×,+-=q "

    // MARK: - Overriden methods

    override func string(for obj: Any?) -> String? {
        if let string = removeNotAllowedChars(in: obj as? String) {
            return formattedText(in: string)
        }
        return nil
    }

    override func editingString(for obj: Any) -> String? {
        return string(for: obj)
    }

    private func formattedText(in text: String) -> String? {
        var text = text.replacingOccurrences(of: "\\b[÷×+-]", with: "\u{00a0}$0", options: .regularExpression)
            .replacingOccurrences(of: "[÷×+-]\\b", with: "$0\u{00a0}", options: .regularExpression)
            .replacingOccurrences(of: "\\s0(\\d)", with: "\u{00a0}$1", options: .regularExpression)
            .replacingOccurrences(of: "^0(\\d)", with: "$1", options: .regularExpression)
            .replacingOccurrences(of: "([÷×+-]),", with: "$1\u{00a0}0,", options: .regularExpression)
            .replacingOccurrences(of: "^,", with: "0,", options: .regularExpression)
            .replacingOccurrences(of: ",([÷×+-])", with: "\u{00a0}$1", options: .regularExpression)
            .replacingOccurrences(of: "^([÷×+-])", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\b\u{003D}", with: "\u{00a0}$0", options: .regularExpression)
            .replacingOccurrences(of: "([÷×+-])(\u{003D})", with: "$1\u{00a0}$2", options: .regularExpression)
            .replacingOccurrences(of: "([,])(\u{003D})", with: "$1\u{00a0}$2", options: .regularExpression)
            .replacingOccurrences(of: "\u{003D}\\b", with: "$0\u{00a0}", options: .regularExpression)
       guard let lastCharacter = text.last else { return text }
        if lastCharacter == "\u{00a0}" {
            text.removeLast()
        }
        return text
    }

    private func removeNotAllowedChars(in string: String?) -> String? {
        string?.filter { allowedChars.contains($0) }
    }

    override func attributedString(for obj: Any, withDefaultAttributes attrs: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString? {
        guard let text = obj as? String, let formattedText = string(for: text) else { return nil }
        let attributedString: NSAttributedString? = toAttributedText(from: formattedText)
        return attributedString
    }

    private func toAttributedText(from text: String) -> NSAttributedString? {
        text.toFormattedExpressionNumber()?
            .separateResult()
            .setAppearance(
                expressionColor: ViewMetrics.expressionColor,
                expressionFont: .font16Regular,
                equalsColor: ViewMetrics.equelsColor,
                equalsFont: .font16Regular)
    }
}
