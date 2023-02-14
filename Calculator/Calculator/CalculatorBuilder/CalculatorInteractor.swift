//
//  CalculatorInteractor.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

protocol CalculatorBuisnessLogic {
    /// Запрос на получение калькулятора
    func getScreen(request: Calculator.GetScreen.Request)

    /// didEditText
    func didEditText(request: Calculator.DidEditText.Request)

    /// didFillText
    func didFillText(request: Calculator.DidFillText.Request)

    /// didFillTextError
    func didFillTextError(request: Calculator.DidFillTextError.Request)

    /// didCleanText
    func didCleanText(request: Calculator.DidCleanText.Request)

}

final class CalculatorInteractor: CalculatorBuisnessLogic {

    let presenter: CalculatorPresentationLogic
    let calculatorWorker: CalculatorWorkerDelegate = CalculatorWorker()
    var fields: String?

    init(presenter: CalculatorPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: Запрос на получение калькулятора
    func getScreen(request: Calculator.GetScreen.Request) {
        presenter.presentScreen(response: Calculator.GetScreen.Response())
    }
    
    // MARK: didEditText
    func didEditText(request: Calculator.DidEditText.Request) {
        presenter.setText(response: Calculator.SetText.Response(text: request.text, shouldNotify: false))
    }

    // MARK: didFillText
    func didFillText(request: Calculator.DidFillText.Request) {
        presenter.setHintLabelText(response: Calculator.SetHintLabelText.Response(text: nil))
        calculate(request.text)
    }

    // MARK: didFillTextError
    func didFillTextError(request: Calculator.DidFillTextError.Request) {
        presenter.setText(response: Calculator.SetText.Response(text: request.text.toFormattedTextMathExpression(), shouldNotify: false))
    }

    // MARK: didCleanText
    func didCleanText(request: Calculator.DidCleanText.Request) {
        presenter.setHintLabelText(response: Calculator.SetHintLabelText.Response(text: nil))
        presenter.setTextFieldState(response: Calculator.SetTextFieldState.Response(state: .focus))
    }

}

extension CalculatorInteractor {


    private func calculate(_ text: String) {
        do {
            let result = try calculatorWorker.getCalculateResult(text)
            presenter.setText(response: Calculator.SetText.Response(text: result, shouldNotify: false))
        } catch let error {
            presenter.setText(response: Calculator.SetText.Response(text: text.toFormattedTextMathExpression(), shouldNotify: false))
            presenter.setTextFieldState(response: Calculator.SetTextFieldState.Response(state: .error((error as? ValidationError)?.message ?? "")))
        }
    }

}
