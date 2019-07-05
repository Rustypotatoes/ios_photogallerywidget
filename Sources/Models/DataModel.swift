//
//  DataModel.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 13/06/2019.
//

import Foundation
import IBACore

enum GalleryStyleType: String, Decodable {
    case list
    case grid
}

struct GalleryStyle: Decodable {
    let type: GalleryStyleType
    private let _columns: String
    var columns: Int {
        return Int(_columns) ?? 2
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case _columns = "columns"
    }
}

struct DataModel: Decodable {
    var colorScheme: ColorSchemeModel?
    
//    var moduleId: String?
    
    var allowsharing: String
    var allowcomments: String
    var allowsaving: String
    
    var style: GalleryStyle
    
    var albums: [AlbumModel]?
    
    enum CodingKeys: String, CodingKey {
        case colorScheme = "colorskin"
//        case moduleId = "module_id"
        case allowsharing = "allowsharing"
        case allowcomments = "allowcomments"
        case allowsaving = "allowsaving"
        case style = "style"
        case albums = "album"
    }
}

extension DataModel {
    var canShare: Bool { return allowsharing == "on" }
    var canSave: Bool { return allowsaving == "on" }
    var canComment: Bool { return allowcomments == "on" }
}
