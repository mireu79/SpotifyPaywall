//
//  PaywallViewController.swift
//  SpotifyPaywall
//
//  Created by joonwon lee on 2022/04/30.
//

import UIKit

// https://developer.spotify.com/documentation/general/design-and-branding/#using-our-logo
// https://developer.apple.com/documentation/uikit/nscollectionlayoutsectionvisibleitemsinvalidationhandler
// 과제: 아래 애플 샘플 코드 다운받아서 돌려보기  https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views

class PaywallViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pagecontroll: UIPageControl!
    
    let bannerInfo: [BannerInfo] = BannerInfo.list
    let colors: [UIColor] = [.systemRed, .systemPink, .systemPurple, .systemOrange]
    
    typealias Item = BannerInfo
    enum Section {
        case main
    }
    
    var dataSouce: UICollectionViewDiffableDataSource<Section, Item>!
    
     override func viewDidLoad() {
        super.viewDidLoad()
         
         dataSouce = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCell else {
                 return nil
             }
             cell.configure(item)
             cell.backgroundColor = self.colors[indexPath.item]
             return cell
         })
         var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
         snapshot.appendSections([.main])
         snapshot.appendItems(bannerInfo, toSection: .main)
         dataSouce.apply(snapshot)
         
         collectionView.collectionViewLayout = layout()
         collectionView.alwaysBounceVertical = false
         
         pagecontroll.currentPage = bannerInfo.count
    }
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20
        
        section.visibleItemsInvalidationHandler = { (item, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            self .pagecontroll.currentPage = index
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
