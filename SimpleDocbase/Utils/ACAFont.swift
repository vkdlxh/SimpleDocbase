//
//  ACAFont.swift
//  SimpleDocbase
//
//  Created by Lee jaeeun on 2017/12/22.
//  Copyright © 2017年 archive-asia. All rights reserved.
//

import UIKit

class ACAFont: UIFont {

    open class func ACAFontSizeL() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0)
    }
    
    open class func ACAFontSizeM() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0)
    }
    
    open class func ACAFontSizeS() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0)
    }
    
    /*!
     * フォントサイズ指定
     */
    open class func ACAFontSize(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}
