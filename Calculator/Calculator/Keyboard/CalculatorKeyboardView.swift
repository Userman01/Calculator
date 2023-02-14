//
//  CalculatorKeyboardView.swift
//  Calculator
//
//  Created by Петр Постников on 19.09.2022.
//

import UIKit

@available(iOS 13.0, *)
final class CalculatorKeyboardView: UIView {

    private enum ViewMetrics {
        static let cornerRadius: CGFloat = 5.0
        static let backgroundColor: UIColor! = .dynamic(light: R.color.lightGray(), dark: R.color.darkMain())
        static let edgeInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
    }

    var dataSource: CalculatorKeyboardDataSource = CalculatorKeyboardDataSource()
    let delegate: CalculatorKeyboardWorkerDelegate = CalculatorKeyboardWorker()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = ViewMetrics.backgroundColor
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(frame: CGRect = .zero, textField: UITextField) {
        super.init(frame: frame)
        delegate.textField = textField
        dataSource.delegate = delegate
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        collectionView.frame = bounds

        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        // item
        let sizeItem = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: sizeItem)
        item.contentInsets = ViewMetrics.edgeInsets

        let sizeItemTwo = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                 heightDimension: .fractionalHeight(1.0))
        let itemTwo = NSCollectionLayoutItem(layoutSize: sizeItemTwo)
        itemTwo.contentInsets = ViewMetrics.edgeInsets

        let sizeItemThree = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                                  heightDimension: .fractionalHeight(1.0))
        let itemThree = NSCollectionLayoutItem(layoutSize: sizeItemThree)
        itemThree.contentInsets = ViewMetrics.edgeInsets

        let sizeItemFour = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),
                                                  heightDimension: .fractionalHeight(1.0))
        let itemFour = NSCollectionLayoutItem(layoutSize: sizeItemFour)
        itemFour.contentInsets = ViewMetrics.edgeInsets

        // group
        let sizeGroupNestedOne = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.2))
        let groupNestedOne = NSCollectionLayoutGroup.horizontal(layoutSize: sizeGroupNestedOne,
                                                                subitem: item, count: 5)
        //
        let sizeGroupNestedOneInOneInTwo = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                  heightDimension: .fractionalHeight(0.5))
        let groupNestedOneInOneInTwo = NSCollectionLayoutGroup.horizontal(layoutSize: sizeGroupNestedOneInOneInTwo,
                                                                          subitem: itemThree, count: 4)
        //
        let sizeGroupNestedOneInTwo = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                             heightDimension: .fractionalHeight(1.0))
        let groupNestedOneInTwo = NSCollectionLayoutGroup.vertical(layoutSize: sizeGroupNestedOneInTwo,
                                                                   subitems: [groupNestedOneInOneInTwo, groupNestedOneInOneInTwo])
        //
        let sizeGroupNestedTwo = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.4))
        let groupNestedTwo = NSCollectionLayoutGroup.horizontal(layoutSize: sizeGroupNestedTwo,
                                                                subitems: [groupNestedOneInTwo, itemTwo])
        //
        let sizeGroupNestedTree = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalHeight(0.2))
        let groupNestedTree = NSCollectionLayoutGroup.horizontal(layoutSize: sizeGroupNestedTree,
                                                                subitems: [item, itemFour, item])
        //
        let sizeGroupPrime = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let groupPrime = NSCollectionLayoutGroup.vertical(layoutSize: sizeGroupPrime,
                                                     subitems: [groupNestedOne, groupNestedTwo, groupNestedTree])

        // section
        let section = NSCollectionLayoutSection(group: groupPrime)
        section.contentInsets = ViewMetrics.edgeInsets
        // Layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
