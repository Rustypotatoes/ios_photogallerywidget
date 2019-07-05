//
//  PhotoGalleryModuleRouter.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 13/06/2019.
//

import IBACore
import IBACoreUI

public enum PhotoGalleyModuleRoute: Route {
    case root
}

public class PhotoGalleryModuleRouter: BaseRouter<PhotoGalleyModuleRoute> {
    var module: PhotoGalleryModule?
    init(with module: PhotoGalleryModule) {
        self.module = module
    }

    public override func generateRootViewController() -> BaseViewControllerType {
        if module?.data?.style.type == .grid {
            return AlbumsViewController<AlbumGridCell>(module: module)
        }
        
        return AlbumsViewController<AlbumRowCell>(module: module)
    }

    public override func prepareTransition(for route: PhotoGalleyModuleRoute) -> RouteTransition {
        return RouteTransition(module: generateRootViewController(), isAnimated: true, showNavigationBar: true, showTabBar: false)
    }

    public override func rootTransition() -> RouteTransition {
        return self.prepareTransition(for: .root)
    }
}
