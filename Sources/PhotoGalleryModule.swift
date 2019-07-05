//
//  PhotoGalleryModule.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 13/06/2019.
//

import UIKit
import IBACore
import IBACoreUI

public class PhotoGalleryModule: BaseModule, ModuleType {
    public var moduleRouter: AnyRouter { return router }
    
    private var router: PhotoGalleryModuleRouter!
    internal var config: WidgetModel?
    internal var data: DataModel?
    
    public override class func canHandle(config: WidgetModel) -> Bool {
        return config.type == "photogallery"
    }
    
    public required init() {
        print("\(type(of: self)).\(#function)")
        super.init()
        router = PhotoGalleryModuleRouter(with: self)
    }
    
    public func setConfig(_ model: WidgetModel) {
        self.config = model
        guard let data = model.data else { return }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
            let decoder = JSONDecoder()
            self.data = try decoder.decode(DataModel.self, from: jsonData)
        } catch {
            print(error)
        }
    }
}
