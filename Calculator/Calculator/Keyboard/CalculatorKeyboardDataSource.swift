//
//  CalculatorKeyboardDataSource.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

final class CalculatorKeyboardDataSource: NSObject, UICollectionViewDataSource {

    weak var delegate: CalculatorKeyboardWorkerDelegate?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithRegistration(type: CalculatorKeyboardCell.self, indexPath: indexPath)
        cell.config(indexPath: indexPath)
        cell.didEditText = {[weak self] string in
            self?.delegate?.insertText(string: string, indexPath: indexPath)
        }
        return cell
    }
}
