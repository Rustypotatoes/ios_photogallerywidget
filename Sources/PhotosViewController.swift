//
//  PhotosViewController.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 03/07/2019.
//

import UIKit
import IBACore
import IBACoreUI

class PhotosViewController: BaseGridViewController<PhotoCell> {
    // MARK: - Private properties
    private var data: AlbumModel?
    private var colorScheme: ColorSchemeModel?
    private var moduleId: String?
    
    // MARK: - Controller life cycle methods
    public convenience init(with colorScheme: ColorSchemeModel?, data: AlbumModel?, moduleId: String?, columns: Int = 2) {
        self.init(with: colorScheme, data: data?.images, columns: columns, padding: 4, spacing: 4)
        self.data = data
        self.colorScheme = colorScheme
        self.moduleId = moduleId
        self.title = data?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onItemSelect = { [unowned self] item in
            self.showPreview(image: item)
        }
    }
    
    func showPreview(image: ImageItemModel) {
        guard let images = data?.images else { return }
        guard let index = images.firstIndex(of: image) else { return }
        
        let controller = PhotoPreviewViewController(with: colorScheme, data: images, moduleId: moduleId, start: index)
        self.navigationController?.pushViewController(controller, animated: true)
//        self.present(controller, animated: true, completion: nil)
    }
}
