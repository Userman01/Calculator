//
//  CalculatorKeyboardDelegate.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

protocol CalculatorKeyboardWorkerDelegate: AnyObject {

    var textField: UITextField? { get set }

    func insertText(string: String, indexPath: IndexPath)
}

final class CalculatorKeyboardWorker: CalculatorKeyboardWorkerDelegate {

    var textField: UITextField?

    func insertText(string: String, indexPath: IndexPath) {
        switch indexPath.row {
        case 16:
            textField?.deleteBackward()
        default:
            textField?.insertText(string)
        }
    }
}
