//
//  DaigoViewController.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import UIKit

public protocol DIGViewerDelegate: AnyObject {
    func daigoCollectionView(_ collectionView: DaigoCollectionView, visibleIndex indexPath: IndexPath)
    func daigoCollectionView(_ collectionView: DaigoCollectionView, didSelectIndex indexPath: IndexPath)
}

open class DaigoViewController: UIViewController {
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.canCancelContentTouches = true
        scrollView.delaysContentTouches = true
        scrollView.minimumZoomScale = 1
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    public weak var delegate: DIGViewerDelegate?

    public let collectionView = DaigoCollectionView(frame: .zero, forwardDirection: .vertical)

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        extendedLayoutIncludesOpaqueBars = true
        collectionView.delegate = self
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        navigationController?.navigationBar.isHidden = true
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top,
                                  width: view.frame.size.width,
                                  height: view.frame.size.height - view.safeAreaInsets.top)
        collectionView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: scrollView.frame.size.width,
                                      height: scrollView.frame.size.height)
    }

    public func reloadData(completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0,
                       animations: { [weak self] in
                           self?.collectionView.reloadData()
                       },
                       completion: { [weak self] finished in
                           guard let weakSelf = self else { return }
                           self?.scrollView.contentSize = CGSize(width: weakSelf.collectionView.contentSize.width,
                                                                 height: weakSelf.collectionView.contentSize.height)
                           self?.collectionView.frame = CGRect(x: weakSelf.collectionView.frame.minX,
                                                               y: weakSelf.collectionView.frame.minY,
                                                               width: weakSelf.collectionView.frame.size.width,
                                                               height: weakSelf.collectionView.contentSize.height)
                           completion?(finished)
                       })
    }
}

extension DaigoViewController: UICollectionViewDelegateFlowLayout {}

extension DaigoViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = delegate else { return }
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX / scrollView.zoomScale, y: visibleRect.midY / scrollView.zoomScale)
        let indexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath()
        delegate.daigoCollectionView(collectionView, visibleIndex: indexPath)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return collectionView
    }
}
