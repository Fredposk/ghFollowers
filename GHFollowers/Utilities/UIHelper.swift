//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Frederico Kuckelhaus on 11.11.21.
//

import UIKit

enum UIHelper {


   static func createUICollectionViewFlowLayout (in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth/2

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth+35)

        return flowLayout
    }

    static func createCollectionViewCompositionalLayout () -> UICollectionViewCompositionalLayout {

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.5), heightDimension: .fractionalWidth(0.5)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)


        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5)), subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)


    }


}
