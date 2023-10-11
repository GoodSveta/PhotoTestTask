//
//  PhotoViewModel.swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import Foundation
import UIKit

enum PaginationState: String {
    case pagingIsReady, isPaging, pagingEnd
}


final class PhotoViewModel: PhotoProtocolIn, PhotoProtocolOut {
    func postData(body: [String : String]) {
        
    }
    
    var dataPhoto = [Content]()
    var dataForShow = [PhotoTest]()
    var dataImage = [PhotoTest]()
    
    var reloadCollectionView: () -> Void = {}
    var showError: (Error) -> Void = { _ in }
    var error = [Error]()
    private var state: PaginationState = .pagingIsReady
    var page = 0
    
    func getData() {
        guard state == .pagingIsReady else { return }
        state = .isPaging
        print("page = \(page)")
        guard let url = APIs.host.getPhotoURL(page: page) else {fatalError("invalid Url")}
        NetworkServiceManager.shared.request(fromURL: url)  { [weak self] (result: Result<PhotoTest, Error>) in
            
            switch result {
            case .success(let dog):
                self?.dataPhoto.append(contentsOf: dog.content)
                self?.page += 1
                print(dog.content.count)
                self?.state = dog.content.count == 0 ? .pagingEnd : .pagingIsReady
                print("state = \(self?.state.rawValue ?? "")")
                self?.reloadCollectionView()
            case .failure(let error):
                self?.error.append(error)
                self?.showError(error)
            }
        }
    }
}
