//
//  CalculatorPresenter.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

protocol CalculatorPresentationLogic {
    /// Показ экрана калькулятора
    func presentScreen(response: Calculator.GetScreen.Response)

    /// Сохранение значения текущего поля
    func presentSetFieldValue(response: Calculator.SetFieldValue.Response)

    /// setText
    func setText(response: Calculator.SetText.Response)

    /// setHintLabelText
    func setHintLabelText(response: Calculator.SetHintLabelText.Response)

    /// setTextFieldState
    func setTextFieldState(response: Calculator.SetTextFieldState.Response)

    /// Закрытие калькулятора
    func close(response: Calculator.DidTapButton.Response)
}

final class CalculatorPresenter: CalculatorPresentationLogic {

    weak var viewController: CalculatorDisplayLogic?

    // MARK: Показ экрана калькулятора
    func presentScreen(response: Calculator.GetScreen.Response) {
        viewController?.displayScreen(viewModel: Calculator.GetScreen.ViewModel(result: getViewModel(response: response)))
    }

    // MARK: Сохранение значения текущего поля
    func presentSetFieldValue(response: Calculator.SetFieldValue.Response) {
        let viewModel = Calculator.SetFieldValue.ViewModel(fields: response.fields)
        viewController?.displaySetFieldValue(viewModel: viewModel)
    }

    // MARK: setText
    func setText(response: Calculator.SetText.Response) {
        viewController?.setText(viewModel: Calculator.SetText.ViewModel(text: response.text, shouldNotify: response.shouldNotify))
    }

    // MARK: setHintLabelText
    func setHintLabelText(response: Calculator.SetHintLabelText.Response) {
        viewController?.setHintLabelText(viewModel: Calculator.SetHintLabelText.ViewModel(text: response.text))
    }

    // MARK: setTextFieldState
    func setTextFieldState(response: Calculator.SetTextFieldState.Response) {
        viewController?.setTextFieldState(viewModel: Calculator.SetTextFieldState.ViewModel(state: response.state))
    }

    // MARK: Закрытие калькулятора
    func close(response: Calculator.DidTapButton.Response) {
        viewController?.close(viewModel: Calculator.DidTapButton.ViewModel())
    }
}

extension CalculatorPresenter {

    private func getViewModel(response: Calculator.GetScreen.Response) -> CalculatorViewModel {
        let textFieldViewModel = TextFieldViewModel(
            uid: "",
            text: "",
            label: "",
            placeholder: nil)
        return CalculatorViewModel(
            title: R.string.localizable.calculatorTitle(),
            textField: textFieldViewModel,
            buttonText: R.string.localizable.calculatorTitleButton())
    }
}
