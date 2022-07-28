//
//  DaigoViewController.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import UIKit

open class DaigoViewController: UIViewController {
    private let collectionView = DaigoCollectionView(frame: .zero, forwardDirection: .up)

    open private(set) var contents: [DaigoContent] = []

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
