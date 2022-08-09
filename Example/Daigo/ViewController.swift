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
        MangaPage(urlString: "https://placehold.jp/3d4070/ffffff/728x1030.png?text=B1", aspectRatio: CGFloat(1030) / CGFloat(728), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/BBDEFB/ffffff/594x841.png?text=A1", aspectRatio: CGFloat(841) / CGFloat(594), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/EC407A/ffffff/515x728.png?text=B2", aspectRatio: CGFloat(728) / CGFloat(515), urlScheme: "https://www.google.com"),
        MangaPage(urlString: "https://placehold.jp/C5E1A5/ffffff/420x594.png?text=A2", aspectRatio: CGFloat(594) / CGFloat(420), urlScheme: nil)
    ]

    private let slider: UISlider = {
        let slider: UISlider = .init()
        slider.alpha = 0
        slider.value = 1
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        slider.backgroundColor = UIColor.white
        return slider
    }()

    private let pageNumber: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        label.clipsToBounds = true
        label.alpha = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let newAppearance = UINavigationBarAppearance()
        newAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = newAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
        navigationItem.title = "タイトル"
        collectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        slider.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
        view.addSubview(slider)
        view.addSubview(pageNumber)
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
        pageNumber.frame = CGRect(x: (view.frame.size.width - 100) / 2,
                                  y: view.frame.size.height - 76,
                                  width: 100,
                                  height: 44)
    }

    override func hiddenBar(isHidden: Bool, animated: Bool) {
        super.hiddenBar(isHidden: isHidden, animated: animated)
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) { [weak self] in
            self?.slider.alpha = isHidden ? 0 : 1
            self?.pageNumber.alpha = isHidden ? 0 : 1
        }
    }
}

extension ViewController {
    @objc private func didChange(_ slider: UISlider) {
        setSliderValue(value: CGFloat(slider.value))
    }
}

extension ViewController: DIGViewerDelegate {
    func aspectRatio(cellForItemAt indexPath: IndexPath) -> CGFloat? {
        guard items.count > indexPath.row else { return nil }
        return items[indexPath.row].aspectRatio
    }

    func daigoCollectionView(_ collectionView: DaigoCollectionView, visibleIndex indexPath: IndexPath) {
        pageNumber.text = "\(indexPath.row + 1)/\(items.count)"
        slider.value = 1 - (Float(indexPath.row) / Float(items.count - 1))
    }

    func daigoCollectionView(_ collectionView: DaigoCollectionView, didSelectIndex indexPath: IndexPath) -> Bool {
        guard items.count > indexPath.row else { return false }
        if let urlSchemeString = items[indexPath.row].urlScheme, let url = URL(string: urlSchemeString) {
            UIApplication.shared.open(url)
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
