//
//  SearchCollectionViewCell.swift
//  SVRFFrameworkSetup
//
//  Created by Andrey Evstratenko on 09/11/2018.
//  Copyright © 2018 SVRF. All rights reserved.
//

import UIKit
import SvrfSDK

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //Change an appearance of cell when selected
    override var isSelected: Bool {
        didSet {
            if isSelected {
                previewImageView.backgroundColor = .darkGray
            } else {
                previewImageView.backgroundColor = .clear
            }
        }
    }
    
    func setupWith(media: SvrfMedia) {
        
        // Set media title
        titleLabel.text = media.title
        
        // Reset media previewImage
        previewImageView.image = nil
        
        // Set media previewImage
        if let previewImageURL = media.files?.images?._720x720 {
            ImageDownloader.imageFromServerURL(previewImageURL) { image in
                self.previewImageView.image = image
            }
        }
    }
}
