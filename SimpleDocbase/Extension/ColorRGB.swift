//
//  ColorRGB.swift
//  SimpleDocbase
//
//  Created by jeonsangjun on 2017/11/21.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

