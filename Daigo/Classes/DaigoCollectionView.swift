//
//  DaigoView.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import UIKit

public final class DaigoCollectionView: UICollectionView {
    public enum ForwardDirection {
        case rightToLeft
        case leftToRight
        case vertical
    }

    var direction: ForwardDirection

    public init(frame: CGRect, forwardDirection: ForwardDirection) {
        direction = forwardDirection
        super.init(frame: frame, collectionViewLayout: DaigoViewBottomToTopLayout())
        backgroundColor = .black
        isUserInteractionEnabled = true
        contentInsetAdjustmentBehavior = .never
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
