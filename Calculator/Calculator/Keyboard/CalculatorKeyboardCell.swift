//
//  CalculatorKeyboardCell.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class CalculatorKeyboardCell: UICollectionViewCell {

    private enum ViewMetrics {
        static let cornerRadius: CGFloat = 5.0
        static let backgroundButton: UIColor! = .dynamic(light: R.color.clearWhite(), dark: R.color.lighterGrey())
        static let titleColor: UIColor! = .dynamic(light: R.color.dark(), dark: R.color.clearWhite())
        static let spacing: CGFloat = 6.0
        static let EdgeInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        static let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        static let shadowOffset = CGSize(width: 0.0, height: 1.0)
        static let shadowOpacity: Float = 1.0
    }

    var didEditText: ((String) -> Void)?

    private let titleButton: [String] = ["-", "1", "2", "3", "+", "÷", "4", "5", "6", "×", "7", "8", "9", "=", ",", "0", "⌫", ""]

    lazy private var button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.tintColor = ViewMetrics.titleColor
        button.setTitleColor(ViewMetrics.titleColor, for: .normal)
        button.layer.cornerRadius = ViewMetrics.cornerRadius
        button.addTarget(self, action: #selector(targetButton), for: .touchDown)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
        isSelected = true
        button.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(indexPath: IndexPath) {
        button.setTitle(titleButton[indexPath.item], for: .normal)
        if indexPath.item == 14 || indexPath.item == 16 {
            button.backgroundColor = nil
        } else {
            button.backgroundColor = ViewMetrics.backgroundButton
            button.layer.shadowColor = ViewMetrics.shadowColor
            button.layer.shadowOffset = ViewMetrics.shadowOffset
            button.layer.shadowOpacity = ViewMetrics.shadowOpacity
            button.layer.shadowRadius = .zero
            button.layer.masksToBounds = false
        }
    }

    @objc private func targetButton() {
        if button.currentTitle == "=" {
            self.didEditText?("q")
        } else {
            self.didEditText?(button.currentTitle ?? "")
        }
    }
}
