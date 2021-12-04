//
//  UIHeaderView.swift
//  UIAnimationBar
//
//  Created by Lazy on 2021/9/5.
//

import UIKit
import DeviceKit

public protocol UIAnimationBarDelegate: AnyObject {
    /// searchCanEdit為false時，觸發該事件
    func didTapTextField()
    /// searchCanEdit為true時，觸發該事件(輸入完畢點擊鍵盤Search按鈕後觸發)
    func didTapSearchBtn(text: String)
    /// 掃描按鈕點擊事件
    func didTapScanBtn()
}

internal var viewWidth = UIScreen.main.bounds.width
internal var viewHeigt = UIScreen.main.bounds.height

/// 自適應大小
/// - Parameter size: 期望大小
/// - Returns: 計算後大小
fileprivate func viewSize(size: CGFloat) -> CGFloat {
    return (size / 414.0) * UIScreen.main.bounds.width
}

/// 計算導航Bar大小
/// - Returns: 尺寸
fileprivate func navigationBarHeight() -> CGFloat {
    return Device.current.isOneOf(iPhone12Device) ? 91 : Device.current.isOneOf(iPhoneXDDevice) ? 88.0 : 64.0
}

private let iPhone12Device: [Device] = [.simulator(.iPhone12), .simulator(.iPhone12ProMax), .iPhone12, .iPhone12Pro, .iPhone12ProMax]
private let iPhoneXDDevice: [Device] = [.iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11Pro, .iPhone11ProMax]

public class UIHeaderView: UIView {

    //MARK: public
    /// 代理協定
    weak public var delegate: UIAnimationBarDelegate? = nil
    /// 搜尋框是否可編輯
    public var searchCanEdit: Bool = true
    /// 左上圖片，建議尺寸為128x18
    public var logoImage: UIImage = UIImage(named: "UIAnimationBar_LOGO", in: UIHeaderViewUtil.fetchBundle(), with: nil)!
    /// 右上掃描按鈕圖片，建議尺寸為24x24
    public var scanImage: UIImage = UIImage(named: "UIAnimationBar_BARCODEW", in: UIHeaderViewUtil.fetchBundle(), with: nil)!.withRenderingMode(.alwaysTemplate)
    /// 搜尋框內放大鏡，建議尺寸為18x18
    public var searchIcon: UIImage = UIImage(named: "UIAnimationBar_SEARCH", in: UIHeaderViewUtil.fetchBundle(), with: nil)!.withRenderingMode(.alwaysTemplate)
    /// 輸入框字型
    public var textFildFont: UIFont = .systemFont(ofSize: 14)
    /// 輸入框佔位符
    public var textFieldPlaceHolder: String = "Search Somethine"
    /// 輸入框預設文字顏色
    public var textFildTextColor: UIColor = .white
    /// 輸入框對左約束加上對右約束(最寬情況，該情況視設計稿而定)
    public var fieldMinLeftWithRighDistance: CGFloat = 32.0
    /// 輸入框對左約束加上對右約束(最窄情況，該情況視設計稿而定)
    public var fieldMaxLeftWithRighDistance: CGFloat = 71.0
    /// 輸入框最小對上距離
    public var fieldMinTopDistance: CGFloat = 5.0
    /// 輸入框最大對上距離
    public var fieldMaxTopDistance: CGFloat = 55.0
    /// 預設輸入框高度
    public var textFieldHeight: CGFloat = 40.0

    //MARK: private
    /// 搜尋框垂直最大偏移量
    /// 該結果為fieldMaxOffsetY減去fieldMinOffsetY
    private lazy var maxOffsetY = {
        return fieldMaxTopDistance - fieldMinTopDistance
    }()

    private var frameworkBundle: Bundle? = nil

    //MARK: Lazy
    /// 標誌圖片
    private lazy var logoImageView: UIImageView = {
        let logoImageView: UIImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRect(x: viewSize(size: 16), y: navigationBarHeight() - 44 + viewSize(size: 16), width: viewSize(size: 128), height: viewSize(size: 18))
        return logoImageView
    }()

    /// 掃描按鈕
    private lazy var scanBtn: UIButton = {
        /// 掃描按鈕
        let scanBtn: UIButton = UIButton(frame: CGRect(x: viewWidth - viewSize(size: 40), y: navigationBarHeight() - 44 + viewSize(size: 13), width: viewSize(size: 24), height: viewSize(size: 24)))
        scanBtn.tintColor = .white
        scanBtn.setImage(scanImage, for: .normal)
        scanBtn.addTarget(self, action: #selector(scanBtnPressed(_:)), for: .touchUpInside)
        return scanBtn
    }()

    /// 搜尋框
    private lazy var searchView: UIView = {
        let view: UIView = UIView()
        view.addSubview(searIcImageView)
        view.addSubview(textField)
        return view
    }()

    private lazy var searIcImageView: UIImageView = {
        let searchImageView: UIImageView = UIImageView(image: searchIcon)
        searchImageView.frame = CGRect(x: viewSize(size: 16), y: viewSize(size: 11), width: viewSize(size: 18), height: viewSize(size: 18))
        searchImageView.tintColor = .white
        return searchImageView
    }()

    private lazy var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.returnKeyType = .search
        textField.font = textFildFont
        textField.textColor = textFildTextColor
        textField.delegate = self
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: navigationBarHeight()))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupSubViews()
    }

    /// 設定子元件
    /// 子元件採用懶加載
    private func setupSubViews() {
        addSubview(logoImageView)
        addSubview(scanBtn)
        addSubview(searchView)
        setSubViewFrameWith(contentOffset: .zero)
    }

    public func setSubViewFrameWith(contentOffset: CGPoint) {
        /// 最小寬度
        let minWidth = viewWidth - viewSize(size: fieldMaxLeftWithRighDistance)
        /// 最大寬度
        let maxWidth = viewWidth - viewSize(size: fieldMinLeftWithRighDistance)
        /// 最小垂直距離
        let minY = Float(navigationBarHeight()) - 44 + Float(viewSize(size: fieldMinTopDistance))
        /// 最大垂直距離
        let maxY = Float(navigationBarHeight()) - 44 + Float(viewSize(size: fieldMaxTopDistance))
        /// 最小透明度
        let minAlpha = 0.0
        /// 最大透明度
        let maxAlpha = 255.0

        let maxColor = 255.0
        let minColor = 133.0

        /*
         偏移比例vertical
         公式：最大垂直偏移量減去當前偏移 / 最大垂直偏移量
         */
        var verticalOffsetPercent: CGFloat = (maxOffsetY - contentOffset.y) / maxOffsetY
        /**
         若偏移比例小於0，則偏移量不再往下遞減
         若偏移比例大於1，則保持最大
         */
        if verticalOffsetPercent <= 0 {
            verticalOffsetPercent = 0
        }
        if verticalOffsetPercent >= 1 {
            verticalOffsetPercent = 1
        }

        /**
         搜尋框設設定
         */
        let y = minY + (maxY - minY) * Float(verticalOffsetPercent)
        let w = minWidth + (maxWidth - minWidth) * verticalOffsetPercent
        searchView.frame = CGRect(x: viewSize(size: 16), y: CGFloat(y), width: w, height: viewSize(size: textFieldHeight))
        textField.frame = CGRect(x: viewSize(size: 40), y: 0, width: w - viewSize(size: textFieldHeight), height: viewSize(size: textFieldHeight))

        /// 透明度
        let alpha = maxAlpha - (maxAlpha - minAlpha) * Double(verticalOffsetPercent)
        backgroundColor = .init(netHex: 0xFFFFFF, alpha: CGFloat(alpha / 255))

        let logoAlapha = minAlpha + (maxAlpha - minAlpha) * Double(verticalOffsetPercent)
        logoImageView.alpha = CGFloat(logoAlapha) / 255

        /// 轉換顏色
        let color = minColor + (maxColor - minColor) * Double(verticalOffsetPercent)

        let currentColor = UIColor(red: CGFloat(color) / 255, green: CGFloat(color) / 255, blue: CGFloat(color) / 255, alpha: 1)

        setupViewRadius(view: searchView, radius: viewSize(size: textFieldHeight / 2), width: 0.5, color: currentColor)
        setTextFieldPlaceHolderColor(color: currentColor)
        searIcImageView.tintColor = currentColor
        scanBtn.tintColor = currentColor
        frame = CGRect.init(x: 0, y: 0, width: viewWidth, height: self.searchView.frame.maxY + viewSize(size: 10))
    }

    /// 設定輸入框父層View的圓角與顏色
    /// - Parameters:
    ///   - view: 哪一個View
    ///   - radius: 多少圓角，預設為textFieldWidth參數除2
    ///   - width: 線框寬度
    ///   - color: 線框顏色
    private func setupViewRadius(view: UIView, radius: CGFloat, width: CGFloat, color: UIColor) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = width
        view.layer.borderColor = color.cgColor
    }

    private func setTextFieldPlaceHolderColor(color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceHolder, attributes: [
            NSAttributedString.Key.foregroundColor: color])
        textField.textColor = color
    }

    @objc
    private func scanBtnPressed(_ sender: UIButton) {
        delegate?.didTapScanBtn()
    }
}

extension UIHeaderView: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !self.searchCanEdit {
            delegate?.didTapTextField()
        }
        return self.searchCanEdit
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.searchCanEdit {
            delegate?.didTapSearchBtn(text: textField.text ?? "")
        }
        return true
    }
}
