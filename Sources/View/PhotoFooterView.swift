//
//  PhotoFooterView.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 05/07/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout
import Lightbox

class CustomFooterView: FooterView {
    
    let toolBar = UIView()
    
    let shareButton = UIButton(type: .custom)
    let slideshowButton = UIButton(type: .custom)
    let commentsButton = UIButton(type: .custom)
    
    var onShare: (() -> Void)?
    var onSlideshow: ((Bool) -> Void)?
    var onComments: (() -> Void)?
    
    override func setup() {
        backgroundColor = UIColor.clear
        
        toolBar.backgroundColor = .clear
        infoLabel.textAlignment = .center
        
        shareButton.setImage(getCoreUIImage(with: "_mPG_share"), for: .normal)
        shareButton.tintColor = .white
        slideshowButton.setImage(getCoreUIImage(with: "_mPG_play"), for: .normal)
        slideshowButton.setImage(getCoreUIImage(with: "_mPG_pause"), for: .selected)
        slideshowButton.tintColor = .white
        commentsButton.setImage(getCoreUIImage(with: "comments"), for: .normal)
        commentsButton.tintColor = .white
        
        flex.define { flex in
            flex.addItem(infoLabel).marginHorizontal(16)
            flex.addItem(separatorView).height(1).marginVertical(8)
            flex.addItem(pageLabel).marginHorizontal(16)
            flex.addItem(toolBar)
                .direction(.row).justifyContent(.spaceAround)
                .height(50).marginTop(8).define({ flex in
                    flex.addItem(shareButton).width(50)
                    flex.addItem(slideshowButton).width(50)
                    flex.addItem(commentsButton).width(50)
                })
        }
        
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        slideshowButton.addTarget(self, action: #selector(slideshow), for: .touchUpInside)
        commentsButton.addTarget(self, action: #selector(comments), for: .touchUpInside)
    }
    
    override func layout() {
        flex.layout(mode: .adjustHeight)
    }
    
    @objc func share() {
        onShare?()
    }
    
    @objc func slideshow() {
        slideshowButton.isSelected = !slideshowButton.isSelected
        
        onSlideshow?(slideshowButton.isSelected)
    }
    
    @objc func comments() {
        onComments?()
    }
}
