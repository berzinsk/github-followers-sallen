//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Karlis Berzins on 14/02/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
