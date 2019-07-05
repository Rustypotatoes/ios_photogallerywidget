//
//  PhotoCommentsViewController.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 05/07/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout

import PKHUD

class PhotoCommentsViewController: BaseViewController {
    private var data: ImageItemModel?
    private var colorScheme: ColorSchemeModel?
    private var moduleId: String?
    
    // MARK: - Controller life cycle methods
    convenience init(with colorScheme: ColorSchemeModel?, data: ImageItemModel?, moduleId: String?) {
        self.init()
        self.data = data
        self.colorScheme = colorScheme
        self.moduleId = moduleId
    }
    
    fileprivate var mainView: PhotoCommentsView {
        return self.view as! PhotoCommentsView
    }
    
    override public func loadView() {
        if let data = data, let colorScheme = colorScheme {
            view = PhotoCommentsView(model: data, colorScheme: colorScheme)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vid = data?.id, let mid = moduleId {
            mainView.onSubmitComment = { name, text in
                HUD.show(.progress)
                AppManager.manager.apiService?.postComment(name: name, text: text, for: "\(vid)", of: "photogallery", reply: "0", module: mid, {
                    self.loadComments { comments in
                        HUD.hide()
                        self.mainView.setComments(comments)
                    }
                })
            }
            
            loadComments { comments in
                self.mainView.setComments(comments)
            }
        }
        
        mainView.onAddComment = { comment in
            let vc = CommentReplyViewController<ImageItemModel>(with: self.colorScheme, item: self.data, comment: comment, moduleId: self.moduleId)
            vc.canComment = true
            vc.onReplyPosted = {
                self.loadComments { comments in
                    self.mainView.setComments(comments)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadComments(_ completion: @escaping ([Comment])->Void) {
        if let vid = data?.id, let mid = moduleId {
            AppManager.manager.apiService?.getComments(for: "\(vid)", of: "photogallery", reply: "0", module: mid) { comments in
                completion(comments)
            }
        }
    }
}
