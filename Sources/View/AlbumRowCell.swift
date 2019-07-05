//
//  AlbumRowCell.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 14/06/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout
import Kingfisher

class AlbumRowCell: BaseAlbumCell {
    
    private let previewImageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    override func setup() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        countLabel.font = UIFont.systemFont(ofSize: 16)
        countLabel.lineBreakMode = .byTruncatingTail
        countLabel.numberOfLines = 0
        countLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        
        // Use contentView as the root flex container
        contentView.flex.direction(.row).define { flex in
            flex.addItem(previewImageView).height(100).aspectRatio(1).shrink(1)
            flex.addItem().direction(.column).marginLeft(8).justifyContent(.center).define({ flex in
                flex.addItem(titleLabel).marginTop(8)
                flex.addItem(countLabel).marginTop(8)
            })
        }
    }
    
    override func configure(model: ModelType) {
        super.configure(model: model)
        
        titleLabel.text = model.title
        titleLabel.flex.markDirty()
        
        countLabel.text = "\(model.images?.count ?? 0) photos"
        countLabel.flex.markDirty()
        
        if let url = model.coverImageUrl {
            previewImageView.kf.setImage(with: url, placeholder: getCoreUIImage(with: "placeholder_image"))
        } else {
            previewImageView.image = getCoreUIImage(with: "placeholder_image")
        }
        flex.layout()
    }
    
    override func setColorScheme(_ colorScheme: ColorSchemeModel) {
        super.setColorScheme(colorScheme)
        titleLabel.textColor = colorScheme.secondaryColor
    }
}
