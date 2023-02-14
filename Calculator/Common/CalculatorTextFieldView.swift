//
//  CalculatorTextFieldView.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class CalculatorTextFieldView: TextFieldView {

    init(label: String?,
         hasLabelAnimation: Bool) {
        super.init(label: label,
                   hasLabelAnimation: hasLabelAnimation,
                   formatter: CalculatorFormatter(),
                   validator: CalculatorValidator())
        if #available(iOS 13.0, *) {
            textField.inputView = CalculatorKeyboardView(textField: textField)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func validate() {
        super.validate()
        if case .error = getState() {
            didFillText?(getText())
        }
    }

    override func set(text: String, shouldNotify: Bool = true) {
        if text.isEmpty {
            self.textField.text = text
        } else {
            if let formatter = formatter, let attributedString = formatter.attributedString(for: text, withDefaultAttributes: nil) {
                self.textField.attributedText = attributedString
            } else {
                self.textField.text = text
            }
        }
        if shouldNotify {
            textFieldEditingChanged(textField)
        }
        setCursor()
    }

    private func setCursor() {
        let positionOriginal = textField.beginningOfDocument

        if let selectedRange = textField.selectedTextRange, let textCount = textField.text?.toFormattedTextMathExpression().count {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
            if cursorPosition > textCount {
                let cursorLocation = textField.position(from: positionOriginal, offset: textCount - 1)

                if let cursorLocation = cursorLocation {
                    textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
                }
            }
        }
    }
}
