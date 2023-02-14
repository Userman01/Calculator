//
//  CalculatorBuilder.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//
import Foundation
import UIKit

final class CalculatorBuilder {

    func build() -> UIViewController {
        let presenter = CalculatorPresenter()
        let interactor = CalculatorInteractor(presenter: presenter)
        let controller = CalculatorViewController(interactor: interactor)

        presenter.viewController = controller
        return controller
    }
}
