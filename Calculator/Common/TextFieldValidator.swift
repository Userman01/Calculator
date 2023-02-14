//
//  TextFieldValidator.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit.UITextField

extension UITextField {
    func validatedText(validator: ValidatorProtocol) throws -> String {
        return try validator.validated(self.text ?? "")
    }
}

extension TextFieldView {
    func validatedText(validator: ValidatorProtocol) throws -> String {
        return try validator.validated(self.getText())
    }
}
