//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

protocol CalculatorDisplayLogic: AnyObject {
    /// Отображение экрана калькулятора
    func displayScreen(viewModel: Calculator.GetScreen.ViewModel)

    /// Сохранение значения текущего поля
    func displaySetFieldValue(viewModel: Calculator.SetFieldValue.ViewModel)

    /// setText
    func setText(viewModel: Calculator.SetText.ViewModel)

    /// setHintLabelText
    func setHintLabelText(viewModel: Calculator.SetHintLabelText.ViewModel)

    ///  setTextFieldState
    func setTextFieldState(viewModel: Calculator.SetTextFieldState.ViewModel)

    /// Закрытие калькулятора
    func close(viewModel: Calculator.DidTapButton.ViewModel)
}

protocol CalculatorViewControllerDelegate: AnyObject {
    func didTapButton(_ text: String)

    func didEditText(_ text: String)

    func didFillText(_ text: String)

    func didFillTextError(_ text: String)

    func didCleanText()
}

final class CalculatorViewController: UIViewController {

    let interactor: CalculatorBuisnessLogic

    lazy var customView = self.view as? CalculatorView

    private let transitionDelegate = CalculatorTransitionDelegate()

    init(interactor: CalculatorBuisnessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        addObserverKeyboardShow()
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = CalculatorView(delegate: self)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getScreen()
    }

    // MARK: Запрос на получение экрана калькулятора
    private func getScreen() {
        interactor.getScreen(request: Calculator.GetScreen.Request())
    }

    private func addObserverKeyboardShow() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardAppear(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc private func handleKeyboardAppear(notification: NSNotification?) {
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        customView?.keyboardWillShow(keyboardHeight: keyboardFrame.cgRectValue.height)
        presentationController?.containerViewDidLayoutSubviews()
    }
}

extension CalculatorViewController: CalculatorDisplayLogic {

    // MARK: Отображение экрана калькулятора
    func displayScreen(viewModel: Calculator.GetScreen.ViewModel) {
        customView?.configure(with: viewModel.result)
    }

    // MARK: Сохранение значения текущего поля
    func displaySetFieldValue(viewModel: Calculator.SetFieldValue.ViewModel) {
    }

    // MARK: setText
    func setText(viewModel: Calculator.SetText.ViewModel) {
        customView?.set(text: viewModel.text, shouldNotify: viewModel.shouldNotify)
    }

    // MARK: setHintLabelText
    func setHintLabelText(viewModel: Calculator.SetHintLabelText.ViewModel) {
        customView?.setHintLabelText(text: viewModel.text)
    }

    // MARK: setTextFieldState
    func setTextFieldState(viewModel: Calculator.SetTextFieldState.ViewModel) {
        customView?.setTextFieldState(state: viewModel.state)
    }

    // MARK: Закрытие калькулятора
    func close(viewModel: Calculator.DidTapButton.ViewModel) {
        self.dismiss(animated: true)
    }
}

extension CalculatorViewController: CalculatorViewControllerDelegate {

    func didTapButton(_ text: String) {
        dismiss(animated: true)
    }

    func didEditText(_ text: String) {
        interactor.didEditText(request: Calculator.DidEditText.Request(text: text))
    }

    func didFillText(_ text: String) {
        interactor.didFillText(request: Calculator.DidFillText.Request(text: text))
    }

    func didFillTextError(_ text: String) {
        interactor.didFillTextError(request: Calculator.DidFillTextError.Request(text: text))
    }

    func didCleanText() {
        interactor.didCleanText(request: Calculator.DidCleanText.Request())
    }
}
