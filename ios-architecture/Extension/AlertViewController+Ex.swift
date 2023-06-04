//
//  AlertViewController+Ex.swift
//  ios-architecture
//
//  Created by AIR on 2023/06/04.
//

import Foundation
import UIKit

protocol AlertViewController where Self: UIViewController {
    typealias closure = ((UIAlertAction) -> Void)?
    func failure(title: String, message: String, retry: String, retryHandler: closure, cancelHandler: closure) -> Bool
}

extension AlertViewController{
    func failure(title: String, message: String, retry: String, retryHandler: closure, cancelHandler: closure = nil) -> Bool {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action: UIAlertAction = UIAlertAction(title: retry, style: UIAlertAction.Style.default, handler: retryHandler)
        let cancel: UIAlertAction  = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler: cancelHandler)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        return true
    }
}
