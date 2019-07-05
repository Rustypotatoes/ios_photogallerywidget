//
//  PhotoCommentsView.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 03/07/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout

public class PhotoCommentsView: UIView {
    private let contentView = UIScrollView()
    private let rootFlexContainer = UIView()
    
    public let imageView = UIImageView()
    public let titleLabel = UILabel()
    public let commentsLabel = UILabel()
    public let contentTextView = GrowingTextView()
    
    public let commentsConteiner = UIView()
    public let inputConteiner = UIView()
    public var commentInputView: TextInputView!
    
    var onAddComment: ((_ model: Comment) -> Void)?
    
    var onSubmitComment: ((_ name: String, _ text: String) -> Void)?
    
    private let model: ImageItemModel
    private let colorScheme: ColorSchemeModel
    
    private var commentViews: [CommentView] = []
    
    init(model: ImageItemModel, colorScheme: ColorSchemeModel) {
        self.model = model
        self.colorScheme = colorScheme
        super.init(frame: .zero)
        
        backgroundColor = colorScheme.backgroundColor
        
        commentInputView = TextInputView(colorScheme: colorScheme)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = colorScheme.accentColor
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        
        commentsLabel.font = .systemFont(ofSize: 16)
        commentsLabel.textColor = colorScheme.secondaryColor
        commentsLabel.lineBreakMode = .byTruncatingTail
        commentsLabel.numberOfLines = 0
        commentsLabel.text = Localization.Common.Comments.commets(0)
        
        contentTextView.font = .systemFont(ofSize: 14)
        contentTextView.textColor = colorScheme.textColor
        contentTextView.contentInset = .zero
        contentTextView.backgroundColor = .clear
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        contentTextView.isSelectable = false
        
        rootFlexContainer.flex.define { (flex) in
            flex.addItem().direction(.row).margin(8).define({ flex in
                if model.imageUrl != nil {
                    flex.addItem(imageView).width(20%).aspectRatio(1).marginRight(8)
                }
                flex.addItem().direction(.column).grow(1).shrink(1).define({ flex in
                    flex.addItem(titleLabel)
                    flex.addItem(contentTextView)
                })
            })
            
            flex.addItem().height(1).backgroundColor(.lightGray)
            flex.addItem(commentsLabel).marginHorizontal(20).marginVertical(8)
            flex.addItem().height(1).backgroundColor(.lightGray)
            flex.addItem(commentsConteiner)
        }
        
        contentView.addSubview(rootFlexContainer)
        
        addSubview(contentView)
        
        titleLabel.text = model.title
        titleLabel.flex.markDirty()
        
        contentTextView.text = model.description
        contentTextView.flex.markDirty()
        
        if let url = model.imageUrl {
            imageView.kf.setImage(with: url, placeholder: getCoreUIImage(with: "placeholder_image"))
        }
        
        flex.layout()
        
        addSubview(commentInputView)
        addSubview(inputConteiner)
        
        inputConteiner.backgroundColor = commentInputView.backgroundColor
        
        commentInputView.pin.bottom(pin.safeArea).right().left()
        commentInputView.flex.layout(mode: .adjustHeight)
        inputConteiner.pin.bottomLeft().right().below(of: commentInputView)
        
        commentInputView.onSubmit = { name, text in
            self.onSubmitComment?(name, text)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        commentInputView.pin.bottom(pin.safeArea).right().left()
        commentInputView.flex.layout(mode: .adjustHeight)
        inputConteiner.pin.bottomLeft().right().below(of: commentInputView)
        
        let inputHeight = commentInputView.bounds.height + inputConteiner.bounds.height
        
        // 1) Layout the contentView & rootFlexContainer using PinLayout
        contentView.pin.all(pin.safeArea)
        rootFlexContainer.pin.top().left().right()
        
        // 2) Let the flexbox container layout itself and adjust the height
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        
        // 3) Adjust the scrollview contentSize
        var size = rootFlexContainer.frame.size
        size.height += inputHeight
        contentView.contentSize = size
    }
    
    func setComments(_ comments: [Comment]) {
        commentsLabel.text = Localization.Common.Comments.commets(comments.count)
        commentsLabel.flex.markDirty()
        
        for view in commentViews {
            view.isHidden = true
            view.flex.isIncludedInLayout(false)
            view.removeFromSuperview()
        }
        
        commentViews.removeAll()
        
        commentsConteiner.flex.define { flex in
            for comment in comments {
                let view = CommentView(model: comment, colorScheme: colorScheme)
                view.onAddComment = { comment in
                    self.onAddComment?(comment)
                }
                self.commentViews.append(view)
                flex.addItem(view)
            }
        }
        
        commentsConteiner.flex.markDirty()
        
        setNeedsLayout()
    }
}
