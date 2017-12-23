//
//  UIViewExtension.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/12/22.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
