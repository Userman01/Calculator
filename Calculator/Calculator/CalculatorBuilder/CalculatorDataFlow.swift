//
//  CalculatorDataFlow.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

enum Calculator {

    // MARK: Получение калькулятора
    enum GetScreen {
        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
            let result: CalculatorViewModel
        }
    }

    // MARK: Сохранение значения текущего поля
    enum SetFieldValue {
        struct Request {
            let fieldValue: String
        }

        struct Response {
            let fields: String?
        }

        struct ViewModel {
            let fields: String?
        }
    }

    // MARK: didEditText
    enum DidEditText {
        struct Request {
            let text: String
        }
    }

    // MARK: didFillText
    enum DidFillText {
        struct Request {
            let text: String
        }
    }

    // MARK: didFillTextError
    enum DidFillTextError {
        struct Request {
            let text: String
        }
    }

    // MARK: didCleanText
    enum DidCleanText {
        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    // MARK: didTapButton
    enum DidTapButton {
        struct Request {
            let text: String
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    enum SetText {
        struct Response {
            let text: String
            let shouldNotify: Bool
        }

        struct ViewModel {
            let text: String
            let shouldNotify: Bool
        }
    }

    // MARK: didCleanText
    enum SetHintLabelText {
        struct Response {
            var text: String?
        }

        struct ViewModel {
            var text: String?
        }
    }

    // MARK: SetTextFieldState
    enum SetTextFieldState {
        struct Response {
            let state: TextFieldView.TextViewState
        }

        struct ViewModel {
            let state: TextFieldView.TextViewState
        }
    }
}
