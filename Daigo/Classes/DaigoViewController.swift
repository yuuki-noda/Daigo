//
//  DaigoViewController.swift
//  Daigo
//
//  Created by yuki noda on 2022/07/28.
//

import UIKit

public protocol DIGViewerDelegate: AnyObject {
    func daigoCollectionView(_ collectionView: DaigoCollectionView, visibleIndex indexPath: IndexPath)
    /// return true -> toggle header, return false -> don't toggle header
    func daigoCollectionView(_ collectionView: DaigoCollectionView, didSelectIndex indexPath: IndexPath) -> Bool
    func aspectRatio(cellForItemAt indexPath: IndexPath) -> CGFloat
}

open class DaigoViewController: UIViewController {
    public let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.zoomScale = 1
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    public let collectionView = DaigoCollectionView(frame: .zero, forwardDirection: .vertical)

    public weak var delegate: DIGViewerDelegate?

    public var currentIndex: Int = 0

    /// vertical: top is 1, bottom is 0
    public func setSliderValue(value: CGFloat) {
        if collectionView.direction == .vertical {
            let percent = 1 - value
            let xPosition = scrollView.contentOffset.x
            let yPosition = (collectionView.contentSize.height - scrollView.frame.size.height) * percent
            let point = CGPoint(x: xPosition, y: yPosition)
            scrollView.scrollRectToVisible(CGRect(origin: point, size: scrollView.frame.size), animated: true)
        }
    }

    private var headerHidden: Bool = true

    private lazy var zoomGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()

    private lazy var toggleGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        gesture.require(toFail: zoomGesture)
        return gesture
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        extendedLayoutIncludesOpaqueBars = true
        collectionView.delegate = self
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        view.addGestureRecognizer(zoomGesture)
        view.addGestureRecognizer(toggleGesture)
        hiddenBar(isHidden: true, animated: true)
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

    open func hiddenBar(isHidden: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
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

extension DaigoViewController {
    @objc private func singleTap(_ sender: UITapGestureRecognizer) {
        let point: CGPoint = sender.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: point),
           let delegate = delegate {
            if delegate.daigoCollectionView(collectionView, didSelectIndex: indexPath) {
                return
            } else {
                headerHidden.toggle()
                hiddenBar(isHidden: headerHidden, animated: true)
            }
        } else {
            headerHidden.toggle()
            hiddenBar(isHidden: headerHidden, animated: true)
        }
    }

    @objc private func doubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1 {
            guard let indexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else { return }
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            scrollView.zoom(to: cell.frame, animated: true)
        } else {
            let point = sender.location(in: collectionView)
            scrollView.zoom(
                to: CGRect(
                    x: point.x - (scrollView.frame.size.width / 4),
                    y: point.y - (scrollView.frame.size.width / 4),
                    width: scrollView.frame.size.width / 2,
                    height: scrollView.frame.size.height / 2
                ),
                animated: true
            )
        }
    }
}

extension DaigoViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let aspectRatio = delegate?.aspectRatio(cellForItemAt: indexPath) else { return UIScreen.main.bounds.size }
        let height = UIScreen.main.bounds.size.width * aspectRatio
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }
}

extension DaigoViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX / scrollView.zoomScale, y: visibleRect.midY / scrollView.zoomScale)
        let indexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath()
        delegate?.daigoCollectionView(collectionView, visibleIndex: indexPath)
        currentIndex = indexPath.row
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == self.scrollView {
            return collectionView
        } else {
            return nil
        }
    }
}
