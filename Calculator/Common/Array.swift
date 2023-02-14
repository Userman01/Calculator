//
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
