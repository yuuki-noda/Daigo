//
//  PageCollectionViewCell.swift
//  Daigo_Example
//
//  Created by yuki noda on 2022/08/01.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Nuke
import UIKit

final class PageCollectionViewCell: UICollectionViewCell {
    private let page = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(page)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        page.frame = CGRect(x: contentView.frame.minX, y: contentView.frame.minY, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }

    func configure(urlString: String) {
        Nuke.loadImage(with: URL(string: urlString), into: page)
    }
}
