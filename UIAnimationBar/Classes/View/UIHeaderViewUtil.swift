//
//  UIHeaderViewUtil.swift
//  UIAnimationBar
//
//  Created by Lazy on 2021/9/5.
//

import Foundation

class UIHeaderViewUtil {

    private static var sharedConfig = UIHeaderViewUtil()

    private static var frameworkBundle: Bundle? = nil

    private init() { }

    static func fetchBundle() -> Bundle? {

        if self.frameworkBundle == nil {
            frameworkBundle = Bundle(path: Bundle(for: UIHeaderViewUtil.self).path(forResource: "UIAnimationBarResource", ofType: "bundle") ?? "")
        }
        return frameworkBundle
    }
}

extension UIColor {

    convenience init(argb: Int) {
        let red: CGFloat = CGFloat((argb >> 16) & 0xff) / 255.0
        let green: CGFloat = CGFloat((argb >> 8) & 0xff) / 255.0
        let blue: CGFloat = CGFloat(argb & 0xff) / 255.0
        let alpha: CGFloat = CGFloat((argb >> 24) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 十六進制顏色編碼
    /// - Parameters:
    ///   - netHex: 色號
    ///   - alpha: 透明度
    convenience init(netHex: Int, alpha: CGFloat = 1.0) {

        let red: CGFloat = CGFloat((netHex >> 16) & 0xff) / 255.0
        let green: CGFloat = CGFloat((netHex >> 8) & 0xff) / 255.0
        let blue: CGFloat = CGFloat(netHex & 0xff) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
