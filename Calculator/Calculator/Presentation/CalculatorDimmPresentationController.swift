//
//  CalculatorDimmPresentationController.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class CalculatorDimmPresentationController: CalculatorPresentationController {

    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: .zero, alpha: 0.3)
        view.alpha = .zero
        return view
    }()

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmView, at: .zero)

        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1.0
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        dimmView.addGestureRecognizer(tapRecognizer)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedViewController.view.addGestureRecognizer(panRecognizer)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        guard let containerView = containerView else { return }
        dimmView.frame = containerView.frame
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = .zero
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
}

extension CalculatorDimmPresentationController {

    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            block()
        }, completion: nil)
    }
}

extension CalculatorDimmPresentationController {

    @objc private func handle(recognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
}
