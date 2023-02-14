//
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class ActionButton: UIButton {

    enum ButtonStyle {
        case primary
    }

    enum ButtonHeightType {
        case normal
    }

    private enum ViewMetrics {
        static let cornerRadius: CGFloat = 12.0
        static let heightNormal: CGFloat = 50.0
        static let heightMin: CGFloat = 32.0

        static let primaryTitleColor: UIColor! = R.color.clearWhite()
        static let primaryTitleDisabledColor: UIColor! = .dynamic(light: R.color.clearWhite(), dark: R.color.clearWhite()?.withAlphaComponent(0.5))
        static let primaryNormalColor: UIColor! = R.color.blue()
        static let primaryHighlightedColor: UIColor! = R.color.highlightedBlue()
        static let primaryDisabledColor: UIColor! = .dynamic(light: R.color.lightBlue(), dark: R.color.darkBlue())
    }

    var buttonStyle: ButtonStyle
    var heightType: ButtonHeightType

    required init(frame: CGRect = .zero,
                  style: ButtonStyle = .primary,
                  heightType: ButtonHeightType = .normal,
                  title: String? = nil) {
        self.buttonStyle = style
        self.heightType = heightType
        super.init(frame: frame)
        setup(title: title)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String? = nil) {
        switch buttonStyle {
        case .primary:
            titleLabel?.font = .font16Bold
            setTitleColor(ViewMetrics.primaryTitleColor, for: .normal)
            setTitleColor(ViewMetrics.primaryTitleDisabledColor, for: .disabled)
            backgroundColor = ViewMetrics.primaryNormalColor
            layer.cornerRadius = ViewMetrics.cornerRadius
        }
        setTitle(title, for: .normal)
    }

    func setButtonStyle(_ style: ButtonStyle) {
        buttonStyle = style
        setup(title: titleLabel?.text)
    }

    func setTitle(with font: UIFont) {
        titleLabel?.font = font
    }

    func removeBorder() {
        layer.borderWidth = .zero
    }

    override var intrinsicContentSize: CGSize {
        switch heightType {
        case .normal:
            return CGSize(width: frame.size.width, height: ViewMetrics.heightNormal)
        }
    }
}

extension ActionButton {

    override var isEnabled: Bool {
        didSet {
            if buttonStyle == .primary {
                backgroundColor = isEnabled ? ViewMetrics.primaryNormalColor : ViewMetrics.primaryDisabledColor
                layer.borderColor = isEnabled ? ViewMetrics.primaryNormalColor.cgColor : ViewMetrics.primaryDisabledColor.cgColor
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            switch buttonStyle {
            case .primary:
                backgroundColor = isHighlighted ? ViewMetrics.primaryHighlightedColor : ViewMetrics.primaryNormalColor
            default:
                break
            }
        }
    }
}
