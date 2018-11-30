//
//  SearchCollectionView.swift
//  SVRFFrameworkSetup
//
//  Created by Andrey Evstratenko on 09/11/2018.
//  Copyright © 2018 SVRF. All rights reserved.
//

import UIKit
import SVRFClientSwift

// Protocol for notify the view controller about something
protocol SearchCollectionViewDelegate {
    
    // Function that notifies the view controller about media selected
    func mediaSelected(media: Media)
}

class SearchCollectionView: UICollectionView {
    
    // Delegate that realises SearchCollectionViewDelegate protocol's functions
    var customDelegate: SearchCollectionViewDelegate?
    
    // The variable which stores current selected item.
    fileprivate var selectedItem: Media?
    
    // The array which stores all items which must be showed in the collection view
    fileprivate var items: [Media] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the collection view
        configure()
    }
    
    private func configure() {
        
        // Set the collection view's delegate and dataSource
        delegate = self
        dataSource = self
    }
    
    func setupWith(mediaArray: [Media]) {
        
        // Setup items which must be showed in the collection view
        items = mediaArray
    }
}

extension SearchCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return numbers of items in section
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure a collection's view cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCellIdentifier", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        cell.setupWith(media: items[indexPath.row])
        
        if let selectedItem = selectedItem {
            cell.isSelected = items[indexPath.item].title == selectedItem.title
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Remember a selected item
        selectedItem = items[indexPath.row]
        
        // Notify the view controller that media selected
        customDelegate?.mediaSelected(media: items[indexPath.row])
    }
}
