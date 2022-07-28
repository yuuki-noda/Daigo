//
//  DaigoContent.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import Foundation

open class DaigoContent {
    public enum PageViewRepresentation {
        case `class`(AnyClass)
        case nib(UINib, AnyClass)
    }

    public private(set) var representation: PageViewRepresentation

    public init(representation: PageViewRepresentation) {
        self.representation = representation
    }

    open func reuseIdentifier() -> String {
        switch representation {
        case let .class(cellClass):
            return "\(cellClass.self)"
        case let .nib(_, cellClass):
            return "\(cellClass.self)"
        }
    }

    open func size(inRect rect: CGRect, direction: DaigoCollectionView.ForwardDirection, traitCollection: UITraitCollection, isDoubleSpread: Bool) -> CGSize {
        return rect.size
    }
}
