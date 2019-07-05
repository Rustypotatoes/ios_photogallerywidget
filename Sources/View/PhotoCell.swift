//
//  PhotoCell.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 03/07/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout
import Kingfisher

class PhotoCell: UICollectionViewCell, BaseCellType {
    typealias ModelType = ImageItemModel
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var model: ModelType?
    public var onAction: ((ModelType) -> Void)?
    
    private let previewImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.flex.define { flex in
            flex.addItem(previewImageView).aspectRatio(1).shrink(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: ModelType) {
        self.model = model
        
        if let thumbnail = model.thumbnail, let url = URL(string: thumbnail.url) {
            previewImageView.backgroundColor = thumbnail.color.getColor() ?? .red
            previewImageView.kf.setImage(with: url)
        } else if let url = model.imageUrl {
            previewImageView.kf.setImage(with: url, placeholder: getCoreUIImage(with: "placeholder_image"))
        } else {
            previewImageView.image = getCoreUIImage(with: "placeholder_image")
        }
        flex.layout()
        setNeedsLayout()
    }
    
    func setColorScheme(_ colorScheme: ColorSchemeModel) { }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
}
