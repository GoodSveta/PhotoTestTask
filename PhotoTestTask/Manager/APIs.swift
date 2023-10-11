//
//  APIs.swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import Foundation
       
enum APIs: String {

    case host = "https://junior.balinasoft.com/api/v2/photo/type?page=%d"
    case hostpost = "https://junior.balinasoft.com/api/v2/photo"
    
    var url: URL? {
        return URL(string: APIs.host.rawValue + self.rawValue)
    }

    func getPhotoURL(page: Int) -> URL? {
        let string = APIs.host.rawValue 
        let newString = String(format: string, page)
        return URL(string: newString)
    }
    
    func postPhotoURL() -> URL? {
        let string = APIs.hostpost.rawValue
        let newString = String(format: string)
        return URL(string: newString)
    }
}

