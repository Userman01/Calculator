//
//  DirectionalLayoutMargins.swift
//  AebOnlineAppIOS
//
//  Created by Гавриил Михайлов on 12.03.2021.
//  Copyright © 2021 JSB Almazergienbank. All rights reserved.
//

import UIKit

extension UIView {
    func setDirectionalLayoutMargins(_ margins: NSDirectionalEdgeInsets) {
        self.preservesSuperviewLayoutMargins = false
        self.directionalLayoutMargins = margins
    }
}
