//
//  SearchCollectionViewCell.swift
//  SVRFFrameworkSetup
//
//  Created by Andrey Evstratenko on 09/11/2018.
//  Copyright © 2018 SVRF. All rights reserved.
//

import UIKit
import SVRFClientSwift

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //Change an appearance of cell when selected
    override var isSelected: Bool {
        didSet {
            if isSelected {
                previewImageView.backgroundColor = .darkGray
            } else {
                previewImageView.backgroundColor = .lightGray
            }
        }
    }
    
    func setupWith(media: Media) {
        
        // Set media title
        titleLabel.text = media.title
        
        // Set media previewImage
        if let previewImage = media.files?.images?._720x720, let previewUrl = URL(string: previewImage) {
            do {
                previewImageView.image = try UIImage(data: Data(contentsOf: previewUrl))
            } catch {
                print("could not fetch preview image: \(error)")
                previewImageView.backgroundColor = .lightGray
            }
        }
    }
    
    func highLightCell(highLight: Bool) {
        
        // Hightlight cell
        previewImageView.backgroundColor = highLight ? .gray : .clear
    }
}
