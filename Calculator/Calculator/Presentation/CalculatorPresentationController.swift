//
//  CalculatorPresentationController.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

class CalculatorPresentationController: UIPresentationController {

    private enum ViewMetrics {
        static let heightView: CGFloat = 220.0
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect() }
        guard let presentedView = presentedView as? CalculatorView else { return .zero }
        let bounds = containerView.bounds
        let heightY = bounds.height - ViewMetrics.heightView - presentedView.keyboardHeight

        return CGRect(x: .zero,
                      y: heightY,
                      width: bounds.width,
                      height: ViewMetrics.heightView)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let presentedView = presentedView else { return }
        presentedView.clipsToBounds = true
        presentedView.layer.cornerRadius = .spacing20Pt
        presentedView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView?.addSubview(presentedView)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let presentedView = presentedView else { return }
        presentedView.frame = frameOfPresentedViewInContainerView
    }
}
