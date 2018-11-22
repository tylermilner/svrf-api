//
//  SearchCollectionView.swift
//  SVRFFrameworkSetup
//
//  Created by Andrey Evstratenko on 09/11/2018.
//  Copyright © 2018 SVRF. All rights reserved.
//

import UIKit
import SVRFClientSwift

protocol SearchCollectionViewDelegate {
    func mediaSelected(media: Media)
}

class SearchCollectionView: UICollectionView {
    
    var customDelegate: SearchCollectionViewDelegate?
    
    fileprivate var selectedItem: Media?
    fileprivate var items: [Media] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        
        delegate = self
        dataSource = self
    }
    
    func setupWith(mediaArray: [Media]) {
        items = mediaArray
    }
}

extension SearchCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCellIdentifier", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        cell.setupWith(media: items[indexPath.row])
        
        if let selectedItem = selectedItem {
            cell.isSelected = items[indexPath.item].title == selectedItem.title
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItem = items[indexPath.row]
        customDelegate?.mediaSelected(media: items[indexPath.row])
    }
}
