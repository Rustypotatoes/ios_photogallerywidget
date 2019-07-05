//
//  ImageItemModel.swift
//  PhotoGalleryModule
//
//  Created by Anton Boyarkin on 02/07/2019.
//

import Foundation
import IBACoreUI

struct ImageThumbnailModel: Decodable, Equatable {
    var color: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case color
        case url
    }
}

struct ImageItemModel: Decodable, CellModelType, Equatable {
    var id: Int64
    var title: String
    var description: String
    var url: String
    var thumbnail: ImageThumbnailModel?
    
    enum CodingKeys: String, CodingKey {
        case id = "#id"
        case title = "#title"
        case description = "#description"
        case url = "#url"
        case thumbnail
    }
}

extension ImageItemModel {
    
    var imageUrl: URL? {
        guard !url.isEmpty else { return nil }
        
        return URL(string: url)
    }
    
}

extension ImageItemModel: CommentItemType {
    static var type: String = "photogallery"
}
