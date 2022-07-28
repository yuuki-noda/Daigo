//
//  DaigoView.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import UIKit

public final class DaigoCollectionView: UICollectionView {
    public enum ForwardDirection {
        case right
        case left
        case up
    }

    public init(frame: CGRect, forwardDirection: ForwardDirection) {
        super.init(frame: frame, collectionViewLayout: DaigoViewBottomToTopLayout())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
