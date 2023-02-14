//
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

extension UICollectionView {

    static func defaultReuseId(for elementType: UIView.Type) -> String {
        return String(describing: elementType)
    }

    func dequeueReusableCellWithRegistration<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath, reuseId: String? = nil) -> T {
        let normalizedReuseId = reuseId ?? UICollectionView.defaultReuseId(for: T.self)

        register(type, forCellWithReuseIdentifier: normalizedReuseId)
        return dequeueReusableCell(withReuseIdentifier: normalizedReuseId, for: indexPath) as! T
    }
}
