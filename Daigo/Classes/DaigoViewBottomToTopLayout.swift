//
//  DaigoViewBottomToTopLayout.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import Foundation

final class DaigoViewBottomToTopLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
