//
//  Extension.swift
//  PhotoTest
//
//  Created by mac on 9.10.23.
//

import UIKit

extension UIViewController {
    func showAlert(with messageError: String) {
        let alert = UIAlertController(title: nil, message: messageError, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

