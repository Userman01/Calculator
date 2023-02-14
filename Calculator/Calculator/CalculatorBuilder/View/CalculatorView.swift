//
//  CalculatorView.swift
//  AebOnlineAppIOS
//
//  Created by Петр Постников on 04.09.2022.
//  Copyright © 2022 JSB Almazergienbank. All rights reserved.
//

import UIKit

final class CalculatorView: UIView {

    private enum ViewMetrics {
        static let backgroundColor: UIColor! = .backgroundColor
        static let tableContentInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        static let margins: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: .spacing32Pt,
            leading: .spacing16Pt,
            bottom: .zero,
            trailing: .spacing16Pt)
    }

    private weak var delegate: CalculatorViewControllerDelegate?

    var keyboardHeight: CGFloat = .zero

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.rectangle()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimaryColor
        label.font = .font20Bold
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textFieldView: CalculatorTextFieldView = {
        let textFieldView = CalculatorTextFieldView(label: nil, hasLabelAnimation: true)
        textFieldView.didEditText = { [weak self] text in
            self?.didEditText(text)
        }
        textFieldView.didFillText = { [weak self] text in
            self?.didFillText(text)
        }
        textFieldView.didCleanText = {  [weak self] in
            self?.didCleanText()
        }
        textFieldView.textField.clearButtonMode = .always
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()

    private lazy var button: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(frame: CGRect = .zero, delegate: CalculatorViewControllerDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        setDirectionalLayoutMargins(ViewMetrics.margins)

        backgroundColor = ViewMetrics.backgroundColor
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(textFieldView)
        addSubview(button)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacing8Pt),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            textFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            button.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: .spacing20Pt),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacing36Pt),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacing36Pt)
        ])
    }

    func configure(with viewModel: CalculatorViewModel) {
        titleLabel.text = viewModel.title
        button.setTitle(viewModel.buttonText, for: .normal)
        textFieldView.formatter = CalculatorFormatter()
        textFieldView.set(text: viewModel.textField.text, shouldNotify: false)
        textFieldView.focus()
    }

    func keyboardWillShow(keyboardHeight: CGFloat) {
        self.keyboardHeight = keyboardHeight
    }

    func set(text: String, shouldNotify: Bool) {
        textFieldView.set(text: text, shouldNotify: shouldNotify)
    }

    func setHintLabelText(text: String?) {
        textFieldView.hintLabel.text = text
    }

    func setTextFieldState(state: TextFieldView.TextViewState) {
        textFieldView.set(state: state)
    }

    @objc private func didTapButton() {
        if case .focus = textFieldView.getState() {
            delegate?.didTapButton(textFieldView.getText())
        }
    }

    private func didEditText(_ text: String) {
        delegate?.didEditText(text)
    }

    private func didFillText(_ text: String) {
        if case .focus = textFieldView.getState() {
            delegate?.didFillText(text)
        } else {
            delegate?.didFillTextError(text)
        }
    }

    private func didCleanText() {
        delegate?.didCleanText()
    }
}
