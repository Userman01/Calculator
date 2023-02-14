//
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import Foundation

extension String {
    /// Возвращает форматированную строку суммы
    ///
    /// - Parameters:
    ///     - currencyCode: трёхбуквенный код валюты по стандарту ISO 4217
    ///     - prefix: префикс может быть использован для таких символов как "+" или "-"
    ///     - minimumFractionDigits: минимальное количество знаков в дробной части
    func toFormattedAmount(currencyCode: String? = nil, prefix: String = "", minimumFractionDigits: Int = 2) -> String? {
        guard let number = self.toNumber() else { return nil }
        let amount: String? = number.toFormattedAmount(currencyCode: currencyCode, prefix: prefix, minimumFractionDigits: minimumFractionDigits)
        if let lastChar = self.last, lastChar == "," || lastChar == "." {
            guard let amount = amount else { return nil }
            if currencyCode != nil {
                let amountComponents = amount.components(separatedBy: "\u{00a0}")
                var groups: [String] = []
                for i in amountComponents.indices {
                    if i == amountComponents.count - 2 {
                        groups.append(amountComponents[i] + ",")
                    } else {
                        groups.append(amountComponents[i])
                    }
                }
                return groups.joined(separator: "\u{00a0}")
            } else {
                return amount + ","
            }
        } else {
            return amount
        }
    }

    /// Возвращает Decimal из любой форматированной суммы
    func toDecimal() -> Decimal? {
        let validString = self
            .filter("0123456789.,-".contains)
            .replacingOccurrences(of: ",", with: ".")
        return Decimal(string: validString)
    }

    /// Возвращает модуль Decimal из любой форматированной суммы
    func toAbsDecimal() -> Decimal? {
        return self
            .replacingOccurrences(of: "-", with: "")
            .toDecimal()
    }

    /// Возвращает NSNumber из любой форматированной суммы
    func toNumber() -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        let amountString = self
                .replacingOccurrences(of: ".", with: ",")
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\u{00a0}", with: "")
        return formatter.number(from: amountString)
    }

    /// Возвращает знак валюты из кода валюты
    func getSymbolForCurrencyCode() -> String? {
        let code = self == "RUR" ? "RUB" : self
        let locale = NSLocale(localeIdentifier: "ru_RU")
        return locale.displayName(forKey: .currencySymbol, value: code)
    }

    // Возвращает число в виде строки без лишних символов
    func toNumberString() -> String {
        var amount: String = ""
        self.forEach {
            if $0.isNumber {
                amount += String($0)
            }
            if $0 == "," || $0 == "." {
                amount += "."
            }
        }
        return amount
    }

    private func isCurrencySign() -> Bool {
        if self.count == 1, let char = self.first {
            return char.isCurrencySymbol
        } else {
            return false
        }
    }

    // Возвращает число в виде строки с учетом языка устройства
    func toFormattedNumber(minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 10) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        guard let number = self.toNumber() else { return nil }
        return formatter.string(from: number)
    }
}

extension Numeric {
    /// Возвращает форматированную строку суммы
    ///
    /// - Parameters:
    ///     - currencyCode: трёхбуквенный код валюты по стандарту ISO 4217 или знак валюты вида ₽, € и т.д.
    ///     - prefix: префикс может быть использован для таких символов как "+" или "-"
    ///     - minimumFractionDigits: минимальное количество знаков в дробной части
    func toFormattedAmount(currencyCode: String? = nil, prefix: String = "", minimumFractionDigits: Int = 2) -> String? {
        guard let number = self as? NSNumber else { return nil }
        return number.toFormattedAmount(currencyCode: currencyCode, prefix: prefix, minimumFractionDigits: minimumFractionDigits)
    }

    /// Преобразует в строку
       func toSimpleString() -> String? {
           let converted = String(describing: self)
           return converted
       }
}

extension Decimal {

    /// Преобразует в строку
    /// - Returns: Строковое представление Decimal с оставлением максимум двух знаков после запятой
    func toString() -> String {
        let converted = String(describing: self)
        let splitted = converted.split(separator: ".", maxSplits: 2, omittingEmptySubsequences: false)
        if splitted.isEmpty {
            return ""
        }
        if let fraction = splitted[safe: 1]?.suffix(2) {
            return String(splitted[0] + "." + fraction)
        }
        return String(splitted[0])
    }
}

extension NSNumber {
    /// Возвращает форматированную строку суммы
    ///
    /// - Parameters:
    ///     - currencyCode: трёхбуквенный код валюты по стандарту ISO 4217 или знак валюты вида ₽, € и т.д.
    ///     - prefix: префикс может быть использован для таких символов как "+" или "-"
    ///     - minimumFractionDigits: минимальное количество знаков в дробной части
    func toFormattedAmount(currencyCode: String? = nil, prefix: String = "", minimumFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = minimumFractionDigits
        if let currencyCode = currencyCode {
            let currency = currencyCode == "RUR" ? "RUB" : currencyCode
            formatter.currencyCode = currency
            if currencyCode.count != 3 && !currencyCode.isEmpty {
                formatter.currencySymbol = ""
            }
            if let numberString = formatter.string(from: self) {
                if currencyCode.count != 3 && !currencyCode.isEmpty {
                    return prefix + numberString + currencyCode
                } else {
                    return prefix + numberString
                }
            } else {
                return nil
            }
        } else {
            formatter.currencySymbol = ""
            if let numberString = formatter.string(from: self) {
                return prefix + String(numberString.dropLast())
            } else {
                return nil
            }
        }
    }
}
