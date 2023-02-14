//
//  SeparatedExpression.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

struct SeparatedMathExpression: Equatable {
    let expressionPart: String
    let equalsPart: String

    init(expressionPart: String = "", equalsPart: String = "") {
        self.expressionPart = expressionPart
        self.equalsPart = equalsPart
    }
}

extension SeparatedMathExpression {
    func setAppearance(expressionColor: UIColor, expressionFont: UIFont, equalsColor: UIColor, equalsFont: UIFont) -> NSAttributedString {
        let expressionAttributes = [NSAttributedString.Key.foregroundColor: expressionColor, NSAttributedString.Key.font: expressionFont]
        let equalsAttributes = [NSAttributedString.Key.foregroundColor: equalsColor, NSAttributedString.Key.font: equalsFont]

        let expressionText = NSAttributedString(string: expressionPart, attributes: expressionAttributes)
        let equalsText = NSAttributedString(string: equalsPart, attributes: equalsAttributes)

        let attributesString = NSMutableAttributedString()
        attributesString.append(expressionText)
        attributesString.append(equalsText)

        return attributesString
    }
}
