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
        MangaPage(urlString: "https://placehold.jp/1290x720.png", aspectRatio: CGFloat(9) / CGFloat(16), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/728x1030.png", aspectRatio: CGFloat(1030) / CGFloat(728), urlScheme: nil),
        MangaPage(urlString: "https://placehold.jp/594x841.png", aspectRatio: CGFloat(841) / CGFloat(594), urlScheme: "custom scheme")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let newAppearance = UINavigationBarAppearance()
        newAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = newAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = newAppearance
        collectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        reloadData(completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: DIGViewerDelegate {
    func daigoCollectionView(_ collectionView: DaigoCollectionView, visibleIndex indexPath: IndexPath) {
        print("visibleIndex: \(indexPath.row)")
    }

    func daigoCollectionView(_ collectionView: DaigoCollectionView, didSelectIndex indexPath: IndexPath) {
        print("didSelectIndex: \(indexPath.row)")
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

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard items.count > indexPath.row else { return collectionView.frame.size }
        let height = collectionView.frame.size.width * items[indexPath.row].aspectRatio
        return CGSize(width: collectionView.frame.size.width, height: height)
    }
}
