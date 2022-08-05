//
//  ViewController.swift
//  Daigo
//
//  Created by yuuki-noda on 07/28/2022.
//  Copyright (c) 2022 yuuki-noda. All rights reserved.
//

import Daigo
import UIKit

struct MangaPage {
    let urlString: String
    let aspectRatio: CGFloat
    let urlScheme: String?
}

final class ViewController: DaigoViewController {
    private let items: [MangaPage] = [
        MangaPage(urlString: "https://placehold.jp/728x1030.png", aspectRatio: CGFloat(1030) / CGFloat(728), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/728x1030.png", aspectRatio: CGFloat(1030) / CGFloat(728), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/728x1030.png", aspectRatio: CGFloat(1030) / CGFloat(728), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/728x1030.png", aspectRatio: CGFloat(1030) / CGFloat(728), urlScheme: "custom scheme"),
    ]

    private lazy var slider: UISlider = {
        let slider: UISlider = .init()
        slider.value = 1
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        slider.backgroundColor = UIColor.white
        slider.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let newAppearance = UINavigationBarAppearance()
        newAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = newAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
        collectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        view.addSubview(slider)
        delegate = self
        reloadData(completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slider.frame = CGRect(x: view.frame.size.width - 44,
                              y: view.safeAreaInsets.top + (navigationController?.navigationBar.frame.size.height ?? 0),
                              width: 44,
                              height: view.frame.size.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - (navigationController?.navigationBar.frame.size.height ?? 0))
    }

    override func hiddenBar(isHidden: Bool, animated: Bool) {
        super.hiddenBar(isHidden: isHidden, animated: animated)
        slider.isHidden = isHidden
    }
}

extension ViewController {
    @objc private func didChange(_ slider: UISlider) {
        setSliderValue(value: CGFloat(slider.value))
    }
}

extension ViewController: DIGViewerDelegate {
    func aspectRatio(cellForItemAt indexPath: IndexPath) -> CGFloat {
        guard items.count > indexPath.row else { return UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width }
        return items[indexPath.row].aspectRatio
    }

    func daigoCollectionView(_ collectionView: DaigoCollectionView, visibleIndex indexPath: IndexPath) {
        print("visibleIndex: \(indexPath)")
    }

    func daigoCollectionView(_ collectionView: DaigoCollectionView, didSelectIndex indexPath: IndexPath) -> Bool {
        guard items.count > indexPath.row else { return false }
        if let urlSchemeString = items[indexPath.row].urlScheme {
            print("didSelectIndex: \(urlSchemeString)")
            return true
        }
        return false
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard items.count > indexPath.row else { return UICollectionViewCell() }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PageCollectionViewCell {
            cell.configure(urlString: items[indexPath.row].urlString)
            return cell
        }
        return UICollectionViewCell()
    }
}
