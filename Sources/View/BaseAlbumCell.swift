//
//  BaseAlbumCell.swift
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

class BaseAlbumCell: UICollectionViewCell, BaseCellType {
    typealias ModelType = AlbumModel
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    public var onAction: ((ModelType) -> Void)?
    
    internal var model: ModelType?
    internal var colorScheme: ColorSchemeModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() { }
    
    func configure(model: AlbumModel) {
        self.model = model
    }
    
    func setColorScheme(_ colorScheme: ColorSchemeModel) {
        self.colorScheme = colorScheme
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
}
