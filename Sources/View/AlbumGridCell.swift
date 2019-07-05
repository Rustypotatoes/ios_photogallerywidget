//
//  AlbumGridCell.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 02/07/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout
import Kingfisher

class AlbumGridCell: BaseAlbumCell {
    private let padding: CGFloat = 8
    
    private let previewImageView = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    override func setup() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        countLabel.font = UIFont.systemFont(ofSize: 16)
        countLabel.lineBreakMode = .byTruncatingTail
        countLabel.numberOfLines = 0
        countLabel.textColor = .white
        
        contentView.flex.define { flex in
            flex.addItem(previewImageView).shrink(1).aspectRatio(1)
            flex.addItem().direction(.row)
                .position(.absolute)
                .right(padding).left(padding).bottom(padding)
                .justifyContent(.spaceBetween)
                .define({ flex in
                flex.addItem(titleLabel)
                flex.addItem(countLabel)
            })
        }
    }
    
    override func configure(model: ModelType) {
        super.configure(model: model)
        
        titleLabel.text = model.title
        titleLabel.flex.markDirty()
        
        countLabel.text = "\(model.images?.count ?? 0)"
        countLabel.flex.markDirty()
        
        if let url = model.coverImageUrl {
            previewImageView.kf.setImage(with: url, placeholder: getCoreUIImage(with: "placeholder_image"))
        } else {
            previewImageView.image = getCoreUIImage(with: "placeholder_image")
        }
        flex.layout()
        
        setNeedsLayout()
    }
}
