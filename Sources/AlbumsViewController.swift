//
//  AlbumsViewController.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 01/07/2019.
//

import UIKit
import IBACore
import IBACoreUI

class AlbumsViewController<CellType: BaseAlbumCell>: BaseGridViewController<CellType> {
    // MARK: - Private properties
    /// Widget type indentifier
    private var type: String?
    
    /// Widget config data
    private var data: DataModel?
    private var module: PhotoGalleryModule?
    private var colorScheme: ColorSchemeModel?
    
    // MARK: - Controller life cycle methods
    public convenience init(module: PhotoGalleryModule?) {
        let colorScheme = module?.data?.colorScheme ?? AppManager.manager.appModel()?.design?.colorScheme
        let columns = module?.data?.style.type == .grid ? 2 : 1
        self.init(with: colorScheme, data: module?.data?.albums, columns: columns)
        self.type = module?.config?.type
        self.data = module?.data
        self.colorScheme = colorScheme
        self.module = module
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onItemSelect = { [unowned self] item in
            let vc = PhotosViewController(with: self.colorScheme, data: item, moduleId: self.module?.config?.widgetID, columns: self.data?.style.columns ?? 2)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
