//
//  AlertViewController+Ex.swift
//  ios-architecture
//
//  Created by AIR on 2023/06/04.
//

import Foundation
import UIKit

protocol AlertViewController where Self: UIViewController {
    func failure(title: String, message: String, retry: String, handler: ((UIAlertAction) -> Void)?) -> Bool
}

extension AlertViewController{
    func failure(title: String, message: String, retry: String, handler: ((UIAlertAction) -> Void)?) -> Bool {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action: UIAlertAction = UIAlertAction(title: retry, style: UIAlertAction.Style.default, handler: handler)
        let cancel: UIAlertAction  = UIAlertAction(title: "閉じる", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        return true
    }
}
