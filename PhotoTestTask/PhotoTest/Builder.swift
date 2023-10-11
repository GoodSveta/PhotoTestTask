//
//  Builder.swift
//  PhotoTest
//
//  Created by mac on 10.10.23.
//

import UIKit

final class Builder {
    static func build() -> UIViewController {
        let photoVM = PhotoViewModel()
        let photoVC = PhotoViewController(photoVM: photoVM)
        
        return photoVC
    }
}
