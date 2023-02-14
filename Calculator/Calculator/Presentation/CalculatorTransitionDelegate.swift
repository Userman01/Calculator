//
//  CalculatorTransition.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class CalculatorTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CalculatorDimmPresentationController(presentedViewController: presented, presenting: presenting ?? source)
    }
}
