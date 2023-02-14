//
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

extension UIColor {

    /// Создает цвет, меняющийся в зависимости от текущей темы оформления
    /// - Parameters:
    ///   - light: Цвет для светлой темы
    ///   - dark: Цвет для темной темы
    /// - Returns: Цвет, полученный с `UIColor(dynamicProvider:)`
    static func dynamic(light: UIColor!, dark: UIColor!) -> UIColor? {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }

    /// Светлая тема – background, темная тема – darkMain
    static let backgroundColor = dynamic(light: R.color.background(), dark: R.color.darkMain())

    /// Светлая тема – clearWhite, темная тема – darkMain
    static let clearWhite = dynamic(light: R.color.clearWhite(), dark: R.color.darkMain())

    /// Светлая тема – highlightedDefault, темная тема – highlightedDark
    static let highlightedColor = dynamic(light: R.color.highlightedDefault(), dark: R.color.highlightedDark())

    /// Светлая тема – dark, темная тема – clearWhite
    static let textPrimaryColor = dynamic(light: R.color.dark(), dark: R.color.clearWhite())

    /// Светлая тема – gray, темная тема – lighterGray
    static let textSecondaryColor = dynamic(light: R.color.gray(), dark: R.color.lighterBlue())
}
