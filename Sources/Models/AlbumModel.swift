//
//  AlbumModel.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 24/06/2019.
//

import Foundation
import IBACoreUI

struct AlbumModel: Decodable, CellModelType {
    var id: Int64
    var title: String
    var cover: String
    var url: String?
    var images: [ImageItemModel]?
    
    var allowsharing: String
    var allowcomments: String
    var allowsaving: String
    
    enum CodingKeys: String, CodingKey {
        case id = "#id"
        case title = "#title"
        case cover = "#cover"
        case url = "#url"
        case images = "image"
        
        case allowsharing = "#allowsharing"
        case allowcomments = "#allowcomments"
        case allowsaving = "#allowsaving"
    }
}

extension AlbumModel {
    
    var canShare: Bool { return allowsharing == "on" }
    var canSave: Bool { return allowsaving == "on" }
    var canComment: Bool { return allowcomments == "on" }
    
    var coverImageUrl: URL? {
        guard !cover.isEmpty else { return nil }
        
        return URL(string: cover)
    }
    
}
