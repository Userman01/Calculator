//
//  TextFieldView.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import InputMask
import UIKit

// TODO: Вынести некоторые публичные методы
// Сделать фабрику TextFieldView

protocol TextFieldViewProtocol: UIView {

    var didFillText: ((String) -> Void)? { get set }

    var didCleanText: (() -> Void)? { get set }

    func set(text: String, shouldNotify: Bool)

    func set(placeholder: String?)

    func set(autocapitalizationType: UITextAutocapitalizationType)

    func set(hint: String?)

    func set(maxLength: Int?)

    func set(allowedChars: String?)

    func focus()
}

class TextFieldView: UIView, TextFieldViewProtocol {

    // MARK: View Metrics
    private enum ViewMetrics {
        static let animationDuration: TimeInterval = 0.2

        static let emptyColor: UIColor! = .textSecondaryColor
        static let fillColor: UIColor! = .textSecondaryColor
        static let focusColor: UIColor! = R.color.blue()
        static let errorColor: UIColor! = R.color.destructive()

        static let smallLabelTopSpacing: CGFloat = 0.0

        static let largeLabelTopSpacing: CGFloat = 26.0

        static let textFieldColor: UIColor! = .textPrimaryColor
        static let textFieldHeight: CGFloat = 21.0

        static let textFieldPlaceholderColor: UIColor! = .textSecondaryColor

        static let lineHeight: CGFloat = 1.0

        static let hintInsets = UIEdgeInsets(top: .spacing8Pt, left: 0.0, bottom: 0.0, right: 0.0)
        static let hintColor: UIColor! = .textSecondaryColor
    }

    enum TextViewState {
        case empty
        case fill
        case focus
        case error(String)
    }

    enum HintLabelState {
        case error(String)
        case hint(String?)
        case hidden
    }

    private var state: TextViewState = .empty {
        didSet(previousState) {
            switch (previousState, state) {
            case (.focus, .empty):
                animateToEmptyState()
                setHintLabelState(.hidden)
            case (.error, .empty):
                animateToEmptyState()
                setHintLabelState(.hidden)
            case (_, .fill):
                animateToFillState()
                setHintLabelState(.hint(hintText))
            case (_, .focus):
                animateToFocusState()
                setHintLabelState(.hint(hintText))
            case let (_, .error(text)):
                setHintLabelState(.error(text))
                setErrorState()
            default:
                break
            }
        }
    }

    // Анимация названия поля при вводе значения
    var hasLabelAnimation: Bool
    // Максимальная длина
    private var maxLength: Int?
    // Разрешённые символы
    private var allowedChars: String?
    // Текст подсказки
    private var hintText: String?
    // Автоматический регистр символов
    private var autocapitalizationType: UITextAutocapitalizationType
    // Валидатор
    var validator: ValidatorProtocol?
    // Форматтер
    var formatter: Formatter?
    // Вызывается при редактировании поля
    var didEditText: ((String) -> Void)?
    // Вызывается при заполнении поля
    var didFillText: ((String) -> Void)?
    // Вызывается при очистке поля
    var didCleanText: (() -> Void)?

    // InputMask
    var inputMaskTextFieldDelegate: MaskedTextInputListener?
    var inputMaskExtractedValue: String?
    var didFillInputMask: Bool?

    // MARK: - View properties

    var labelTopAnchorConstraint: NSLayoutConstraint!
    var overrideColor: UIColor?

    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = ViewMetrics.emptyColor
        label.font = hasLabelAnimation ? .font16Regular : .font14Regular
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = ViewMetrics.textFieldColor
        textField.font = .font16Regular
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = ViewMetrics.emptyColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var hintLabel: InsetLabel = {
        let label = InsetLabel()
        label.contentInsets = ViewMetrics.hintInsets
        label.font = .font12Regular
        label.textColor = ViewMetrics.hintColor
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Initialization
    init(label: String?,
         hasLabelAnimation: Bool,
         margins: UIEdgeInsets = .zero,
         keyboardType: UIKeyboardType = .default,
         formatter: Formatter? = nil,
         autocapitalizationType: UITextAutocapitalizationType = .none,
         validator: ValidatorProtocol? = nil,
         inputMask: String? = nil,
         textContentType: UITextContentType? = nil) {
        self.hasLabelAnimation = hasLabelAnimation
        self.formatter = formatter
        self.autocapitalizationType = autocapitalizationType
        self.validator = validator
        super.init(frame: .zero)
        self.label.text = label
        self.layoutMargins = margins
        self.textField.keyboardType = keyboardType
        self.textField.textContentType = textContentType

        if let inputMask = inputMask {
            inputMaskTextFieldDelegate = MaskedTextInputListener(primaryFormat: inputMask)
            inputMaskTextFieldDelegate?.delegate = self
            textField.delegate = inputMaskTextFieldDelegate
        } else {
            textField.delegate = self
        }

        self.setupLayout()
        self.addTapGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addSubview(label)
        addSubview(textField)
        addSubview(lineView)
        addSubview(hintLabel)

        let labelSpacing = hasLabelAnimation ? ViewMetrics.largeLabelTopSpacing : ViewMetrics.smallLabelTopSpacing
        labelTopAnchorConstraint = label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: labelSpacing)
        preservesSuperviewLayoutMargins = false

        NSLayoutConstraint.activate([
            labelTopAnchorConstraint,
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: ViewMetrics.largeLabelTopSpacing),
            textField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: ViewMetrics.textFieldHeight),

            lineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .spacing8Pt),
            lineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: ViewMetrics.lineHeight),

            hintLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            hintLabel.leadingAnchor.constraint(equalTo: lineView.leadingAnchor),
            hintLabel.trailingAnchor.constraint(equalTo: lineView.trailingAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

    @objc func textFieldEditingDidBegin(_ textField: UITextField) {
        if case .error = state { return }
        state = .focus
    }

    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            state = .empty
        } else {
            if case .error = state { return }
            state = .fill
        }
    }

    // MARK: - Private methods
    @objc private func tapAction(_ sender: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
    }

    private func setHintLabelState(_ state: HintLabelState) {
        switch state {
        case let .hint(message):
            if let message = message {
                DispatchQueue.main.async {
                    self.hintLabel.text = message
                }
                hintLabel.textColor = overrideColor ?? ViewMetrics.hintColor
                hintLabel.isHidden = false
            } else {
                hintLabel.isHidden = true
            }
        case let .error(message):
            DispatchQueue.main.async {
                self.hintLabel.text = message
            }
            hintLabel.textColor = overrideColor ?? ViewMetrics.errorColor
            hintLabel.isHidden = false
        case .hidden:
            hintLabel.isHidden = true
        }
    }

    private func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        addGestureRecognizer(recognizer)
    }

    private func animateToEmptyState() {
        label.textColor = overrideColor ?? ViewMetrics.emptyColor
        lineView.backgroundColor = overrideColor ?? ViewMetrics.emptyColor
        hintLabel.textColor = overrideColor ?? ViewMetrics.hintColor

        if hasLabelAnimation {
            labelTopAnchorConstraint.constant = ViewMetrics.largeLabelTopSpacing

            UIView.transition(with: label, duration: ViewMetrics.animationDuration, options: .transitionCrossDissolve) {
                self.layoutIfNeeded()
                self.label.font = .font16Regular
            }
        }
    }

    private func animateToFillState() {
        label.textColor = overrideColor ?? ViewMetrics.fillColor
        lineView.backgroundColor = overrideColor ?? ViewMetrics.fillColor
        hintLabel.textColor = overrideColor ?? ViewMetrics.hintColor

        if hasLabelAnimation {
            labelTopAnchorConstraint.constant = ViewMetrics.smallLabelTopSpacing
            label.font = .font14Regular
        }
    }

    private func animateToFocusState() {
        label.textColor = overrideColor ?? ViewMetrics.focusColor
        lineView.backgroundColor = overrideColor ?? ViewMetrics.focusColor
        hintLabel.textColor = overrideColor ?? ViewMetrics.hintColor

        if hasLabelAnimation {
            labelTopAnchorConstraint.constant = ViewMetrics.smallLabelTopSpacing
            guard label.font == .font16Regular else { return }

            UIView.transition(with: label, duration: ViewMetrics.animationDuration, options: .transitionCrossDissolve) {
                self.label.font = .font14Regular
                self.layoutIfNeeded()
            }
        }
    }

    private func setErrorState() {
        label.textColor = overrideColor ?? ViewMetrics.errorColor
        lineView.backgroundColor = overrideColor ?? ViewMetrics.errorColor
        hintLabel.textColor = overrideColor ?? ViewMetrics.errorColor
    }

    // MARK: - Internal methods

    @objc func textFieldEditingChanged(_ textField: UITextField) {
        let text = getText()
        didEditText?(text)
        validate()
    }

    @objc func getText() -> String {
        if let inputMaskExtractedValue = inputMaskExtractedValue {
            return inputMaskExtractedValue
        } else {
            if self.textField.keyboardType == .decimalPad {
                return self.textField.text?.toNumberString() ?? ""
            } else {
                return self.textField.text ?? ""
            }
        }
    }

    @objc func validate() {
        guard let textValidator = validator else {
            checkText()
            return
        }
        guard textField.text?.isEmpty == false else {
            didCleanText?()
            return
        }
        do {
            state = .focus
            let text = try validatedText(validator: textValidator)
            didFillText?(text)
        } catch let error {
            state = .error((error as? ValidationError)?.message ?? "")
        }
    }

    func validate(shouldNotify: Bool) {
        if shouldNotify {
            validate()
            return
        }
        guard let validator = validator else { return }
        do {
            state = .focus
            _ = try validatedText(validator: validator)
        } catch let error {
            state = .error((error as? ValidationError)?.message ?? "")
        }
    }

    @objc func checkText() {
        let text = getText()
        if text.isEmpty {
            didCleanText?()
        } else {
            didFillText?(text)
        }
    }

    func getState() -> TextViewState {
        return state
    }

    func set(state: TextViewState) {
        self.state = state
    }

    func set(text: String, shouldNotify: Bool = true) {
        if let inputMaskTextFieldDelegate = inputMaskTextFieldDelegate {
            _ = inputMaskTextFieldDelegate.put(text: text, into: textField, autocomplete: true)
        } else {
            if let formatter = formatter, let formattedText = formatter.string(for: text) {
                self.textField.text = formattedText
            } else {
                self.textField.text = text
            }
        }
        if shouldNotify {
            textFieldEditingChanged(textField)
        }
    }

    func set(placeholder: String?) {
        guard let placeholder = placeholder else { return }
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.font16Regular,
            .foregroundColor: ViewMetrics.textFieldPlaceholderColor as UIColor
        ]
        let placeholderAttributedString = NSAttributedString(string: placeholder, attributes: textAttributes)

        let attributedString = NSMutableAttributedString(attributedString: placeholderAttributedString)
        self.textField.attributedPlaceholder = attributedString
    }

    func set(hint: String?) {
        hintText = hint
        hintLabel.text = hint
    }

    func set(label: String) {
        self.label.text = label
    }

    func showHintLabel(isHidden: Bool) {
        hintLabel.isHidden = isHidden
    }

    func set(maxLength: Int?) {
        self.maxLength = maxLength
    }

    func set(allowedChars: String?) {
        self.allowedChars = allowedChars
    }

    func set(keyboardType: UIKeyboardType) {
        self.textField.keyboardType = keyboardType
    }

    func set(autocapitalizationType: UITextAutocapitalizationType) {
        self.autocapitalizationType = autocapitalizationType
    }

    func set(validator: ValidatorProtocol?) {
        self.validator = validator
    }

    func set(inputMask: String?) {
        if let inputMask = inputMask {
            inputMaskTextFieldDelegate = MaskedTextInputListener(primaryFormat: inputMask)
            inputMaskTextFieldDelegate?.delegate = self
            textField.delegate = inputMaskTextFieldDelegate
        } else {
            textField.delegate = self
        }
    }

    func set(color: UIColor?) {
        overrideColor = color
        if let color = color {
            label.textColor = color
            lineView.backgroundColor = color
            hintLabel.textColor = color
        } else {
            set(state: getState())
        }
    }

    func focus() {
        self.textField.becomeFirstResponder()
    }

    func checkAllowedChars(string: String) -> Bool {
        // Ограничение допустимых символов
        let set: CharacterSet?
        switch textField.keyboardType {
        case .numberPad:
            set = CharacterSet(charactersIn: "0123456789")
        case .decimalPad:
            set = CharacterSet(charactersIn: "0123456789,.")
        default:
            guard let allowedChars = allowedChars else { return true }
            set = CharacterSet(charactersIn: allowedChars)
        }
        if let set = set, string.rangeOfCharacter(from: set.inverted) != nil {
            return false
        } else {
            return true
        }
    }

    func checkMaxLength(text: String?, range: NSRange, replacementString: String) -> Bool {
        guard let text = text, let rangeOfTextToReplace = Range(range, in: text) else { return true }
        // Ограничение максимальной длины
        if let maxLength = maxLength {
            let substringToReplace = text[rangeOfTextToReplace]
            return text.count - substringToReplace.count + replacementString.count <= maxLength
        } else {
            return true
        }
    }

    func setCursor(range: NSRange, replacementString: String, previewText: String) {
        let positionOriginal = textField.beginningOfDocument
        if replacementString != "", let text = textField.text {
            let diff = text.count - previewText.count
            let indexFromText: Int = range.location + diff
            let cursorLocation = textField.position(from: positionOriginal, offset: (indexFromText))

            if let cursorLocation = cursorLocation {
                textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
            }
        } else {
            let text = textField.text ?? ""
            let diff = text.count - previewText.count
            var indexFromText: Int = (range.location + (diff < 0 ? 0 : diff))

            if indexFromText < 0 {
                indexFromText = 0
            }
            let cursorLocation = textField.position(from: positionOriginal, offset: indexFromText)
            if let cursorLocation = cursorLocation {
                textField.selectedTextRange = textField.textRange(from: cursorLocation, to: cursorLocation)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension TextFieldView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previewText = textField.text ?? ""

        let text = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        if checkAllowedChars(string: string) && checkMaxLength(text: textField.text, range: range, replacementString: string) {
            guard formatter != nil || autocapitalizationType != .none else { return true }
            if let formattedText = formatter?.editingString(for: text) {
                textField.text = formattedText
                textFieldEditingChanged(textField)
            } else if autocapitalizationType == .allCharacters {
                textField.text = text.uppercased()
                textFieldEditingChanged(textField)
            }
        }

        setCursor(range: range, replacementString: string, previewText: previewText)
        return false
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }
}

// MARK: - OnMaskedTextChangedListener
extension TextFieldView: OnMaskedTextChangedListener {

    func textInput(_ textInput: UITextInput, didExtractValue: String, didFillMandatoryCharacters: Bool) {
        inputMaskExtractedValue = didExtractValue
        didFillInputMask = didFillMandatoryCharacters
        textFieldEditingChanged(textField)
    }
}
