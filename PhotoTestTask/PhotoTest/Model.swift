//
//  Model.swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import Foundation

// MARK: - PhotoTest
struct PhotoTest: Codable {
    let page, pageSize, totalPages, totalElements: Int
    let content: [Content]
}

// MARK: - Content
struct Content: Codable {
    let id: Int
    let name: String
    let image: String?
}
