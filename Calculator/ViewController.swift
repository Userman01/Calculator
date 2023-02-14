//
//  ViewController.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var button: ActionButton = {
        let button = ActionButton(title: "Press")
        button.addTarget(self, action: #selector(didTupButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    @objc private func didTupButton() {
        let controller = CalculatorBuilder()
            .build()
        present(controller, animated: true)
    }

}

