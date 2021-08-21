//
//  UICollectionView+Extension.swift
//  Moother
//
//  Created by 윤예지 on 2021/08/22.
//

import UIKit

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable Dequeue Reusable")
        }
        
        return cell
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionViewCell: NibLoadable { }
extension UICollectionViewCell: ReusableCell { }
