//
//  PhotoProtocols .swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import Foundation

protocol PhotoProtocolIn: AnyObject {
    var dataPhoto: [Content] { get set }
    var dataForShow: [PhotoTest] { get set }
    
    func getData()
    func postData(body: [String: String])
}

protocol PhotoProtocolOut {
    var reloadCollectionView: () -> Void { get set }
    var showError: (Error) -> Void { get set }
}
