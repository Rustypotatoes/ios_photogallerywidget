//
//  PhotoPreviewViewController.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 03/07/2019.
//

import UIKit
import IBACore
import IBACoreUI
import PinLayout
import FlexLayout
import Lightbox

class PhotoPreviewViewController: LightboxController {
    // MARK: - Private properties
    private var data: [ImageItemModel]?
    private var colorScheme: ColorSchemeModel?
    private var moduleId: String?
    
    var autoscrollTimer: AutoCancellingTimer?
    
    // MARK: - Controller life cycle methods
    convenience init(with colorScheme: ColorSchemeModel?, data: [ImageItemModel], moduleId: String?, start index: Int) {
        var lightboxImages = [LightboxImage]()
        
        for image in data {
            if let url = image.imageUrl {
                lightboxImages.append(LightboxImage(imageURL: url, text: image.description))
            }
        }
        
        self.init(images: lightboxImages, startIndex: index)
        
        // Set delegates.
        self.pageDelegate = self
        self.dismissalDelegate = self
        self.imageTouchDelegate = self
        
        // Use dynamic background.
        self.dynamicBackground = true
        
        self.data = data
        self.colorScheme = colorScheme
        self.moduleId = moduleId
        
        if let image = self.data?[index] {
            self.title = image.title
        }
    }
    
    public override var headerView: HeaderView {
        return _headerView
    }
    
    fileprivate(set) lazy var _headerView: HeaderView = { [unowned self] in
        let view = HeaderView()
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    public override var footerView: FooterView {
        return _footerView
    }
    
    fileprivate(set) lazy var _footerView: FooterView = { [unowned self] in
        let view = CustomFooterView()
        view.delegate = self
        
        view.onComments = {
            let image = self.data?[self.currentPage]
            let vc = PhotoCommentsViewController(with: self.colorScheme, data: image, moduleId: self.moduleId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        view.onSlideshow = { isEnabled in
            if isEnabled {
                self.startAutoScroll()
            } else {
                self.stopAutoScroll()
            }
        }
        
        view.onShare = {
            guard let image = self.data?[self.currentPage], let app = AppManager.manager.appModel(), let appConfig = AppManager.manager.config() else { return }
            let appName = app.design?.appName ?? ""
            var message = String(format: Localization.Common.Share.Photo.message, image.url, appName)
            let showLink = app.design?.isShowLink ?? false
            if showLink {
                let link = "https://ibuildapp.com/projects.php?action=info&projectid=\(appConfig.appID)"
                message.append("\n")
                message.append(String(format: Localization.Common.Share.link, appName, link))
                message.append("\n")
                message.append(Localization.Common.Share.postedVia)
            }
            
            let textToShare = [ message ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        return view
    }()
    
    public override func layout() {
        headerView.pin.top(view.pin.safeArea.top).horizontally().height(100)
        footerView.flex.layout(mode: .adjustHeight)
        footerView.pin.bottom(view.pin.safeArea.bottom).horizontally()
    }
    
    func startAutoScroll() {
        autoscrollTimer = AutoCancellingTimer(interval: 5.0, repeats: true) {
            self.next()
        }
    }
    
    func stopAutoScroll() {
        autoscrollTimer = nil
    }
}

extension PhotoPreviewViewController: LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        if let image = data?[page] {
            self.title = image.title
        }
    }
    
}

extension PhotoPreviewViewController: LightboxControllerDismissalDelegate {
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PhotoPreviewViewController: LightboxControllerTouchDelegate {
    
    func lightboxController(_ controller: LightboxController, didTouch image: LightboxImage, at index: Int) {
        self.navigationController?.setNavigationBarHidden(!(self.navigationController?.navigationBar.isHidden ?? true), animated: true)
    }
    
}

final class AutoCancellingTimer {
    private var timer: AutoCancellingTimerInstance?
    
    init(interval: TimeInterval, repeats: Bool = false, callback: @escaping ()->Void) {
        timer = AutoCancellingTimerInstance(interval: interval, repeats: repeats, callback: callback)
    }
    
    deinit {
        timer?.cancel()
    }
    
    func cancel() {
        timer?.cancel()
    }
}

final class AutoCancellingTimerInstance: NSObject {
    private let repeats: Bool
    private var timer: Timer?
    private var callback: ()->Void
    
    init(interval: TimeInterval, repeats: Bool = false, callback: @escaping ()->Void) {
        self.repeats = repeats
        self.callback = callback
        
        super.init()
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self,
                                     selector: #selector(AutoCancellingTimerInstance.timerFired(_:)), userInfo: nil, repeats: repeats)
    }
    
    func cancel() {
        timer?.invalidate()
    }
    
    @objc func timerFired(_ timer: Timer) {
        self.callback()
        if !repeats { cancel() }
    }
}
