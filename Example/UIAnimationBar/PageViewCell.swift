//
//  PageViewCell.swift
//  UIAnimationBar_Example
//
//  Created by Lazy on 2021/9/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class PageViewCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addImageView()
    }

    func addImageView() {
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = bounds
    }
}
